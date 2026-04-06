from typing import List
import numpy as np
import google.generativeai as genai
from config import Settings

class SortSourceService:
    def __init__(self):
        settings = Settings()
        genai.configure(api_key=settings.GEMINI_API_KEY)

    def sort_sources(self, query: str, search_results: List[dict]):
        relevance_scores = []

        query_embedding_response = genai.embed_content(
            model="models/text-embedding-004",
            content=query
        )
        query_embedding = query_embedding_response['embedding']

        for result in search_results:
            content = result.get("content")

            if not content:
                continue

            # We pass the slice to avoid hitting length limits if content is huge
            res_embedding_response = genai.embed_content(
                 model="models/text-embedding-004",
                 content=content[:10000]
            )
            res_embedding = res_embedding_response['embedding']

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