from typing import List
import numpy as np
from google import genai
from config import Settings

class SortSourceService:
    def __init__(self):
        settings = Settings()
        self.client = genai.Client(api_key=settings.GEMINI_API_KEY)

    def sort_sources(self, query: str, search_results: List[dict]):
        relevance_scores = []

        query_embedding_response = self.client.models.embed_content(
            model="text-embedding-004",
            contents=query
        )
        query_embedding = query_embedding_response.embeddings[0].values

        for result in search_results:
            content = result.get("content")

            if not content:
                continue

            # We pass the slice to avoid hitting length limits if content is huge
            res_embedding_response = self.client.models.embed_content(
                 model="text-embedding-004",
                 contents=content[:10000]
            )
            res_embedding = res_embedding_response.embeddings[0].values

            similarity = float(np.dot(query_embedding, res_embedding) / (
                np.linalg.norm(query_embedding) * np.linalg.norm(res_embedding)
            ))

            result["relevance_score"] = float(similarity)

            if similarity > 0.4:
                relevance_scores.append(result)

        return sorted(
            relevance_scores,
            key=lambda x: x["relevance_score"],
            reverse=True
        )