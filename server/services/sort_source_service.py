from typing import List
import numpy as np
from google import genai
from config import Settings


class SortSourceService:
    def __init__(self):
        settings = Settings()
        self.client = genai.Client(api_key=settings.GEMINI_API_KEY)

    def get_embedding(self, text: str):
        try:
            response = self.client.models.embed_content(
                model="text-embedding-004",
                contents=text
            )
            return np.array(response.embeddings[0].values)

        except Exception as e:
            print("Embedding Error:", str(e))
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
        relevance_scores = []

        # ✅ Get query embedding once
        query_embedding = self.get_embedding(query)

        for result in search_results:
            content = result.get("content")

            if not content:
                continue

            # ✅ Limit size to avoid API issues
            content = content[:8000]

            res_embedding = self.get_embedding(content)

            similarity = self.cosine_similarity(query_embedding, res_embedding)

            result["relevance_score"] = similarity

            # ✅ Slightly better threshold
            if similarity > 0.35:
                relevance_scores.append(result)

        return sorted(
            relevance_scores,
            key=lambda x: x["relevance_score"],
            reverse=True
        )