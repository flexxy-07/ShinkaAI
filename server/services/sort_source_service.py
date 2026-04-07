from typing import List
import numpy as np
from google import genai
from config import Settings


class SortSourceService:
    def __init__(self):
        settings = Settings()
        self.client = genai.Client(api_key=settings.GEMINI_API_KEY)

    def get_embeddings(self, texts: List[str]):
        """Fetched embeddings in batch to minimize API hits and quota usage."""
        try:
            # text-embedding-004 is more robust and standard for the new SDK
            response = self.client.models.embed_content(
                model="text-embedding-004",
                contents=texts
            )
            return [np.array(e.values) for e in response.embeddings]

        except Exception as e:
            print(f"Batch Embedding Error: {str(e)}")
            return None

    def cosine_similarity(self, a, b):
        if a is None or b is None:
            return 0.0

        norm_a = np.linalg.norm(a)
        norm_b = np.linalg.norm(b)

        if norm_a == 0 or norm_b == 0:
            return 0.0

        return float(np.dot(a, b) / (norm_a * norm_b))

    def sort_sources(self, query: str, search_results: List[dict]):
        if not search_results:
            return []

        # ✅ Prepare list for batch embedding (query + all contents)
        # We include the query as the first item to get everything in ONE request
        texts_to_embed = [query]
        valid_results = []

        for result in search_results:
            content = result.get("content")
            if content:
                # Limit size to avoid token limits per request
                texts_to_embed.append(content[:5000])
                valid_results.append(result)

        if len(texts_to_embed) < 2:
            return search_results

        # ✅ ONE API CALL instead of N + 1
        print(f"Requesting batch embeddings for {len(texts_to_embed)} items...")
        all_embeddings = self.get_embeddings(texts_to_embed)

        # ✅ FALLBACK: If API fails, return original search results (already ranked by search engine)
        if all_embeddings is None or len(all_embeddings) < 2:
            print("Falling back to default search engine ranking due to API issue/quota.")
            return search_results[:10]  # Return top 10 from search engine

        query_embedding = all_embeddings[0]
        content_embeddings = all_embeddings[1:]

        relevance_scores = []
        for i, res_embedding in enumerate(content_embeddings):
            similarity = self.cosine_similarity(query_embedding, res_embedding)
            
            result = valid_results[i]
            result["relevance_score"] = similarity

            # ✅ Threshold for relevance
            if similarity > 0.30:
                relevance_scores.append(result)

        # If everything filtered out, return top 5 anyway
        if not relevance_scores:
            return valid_results[:5]

        return sorted(
            relevance_scores,
            key=lambda x: x["relevance_score"],
            reverse=True
        )