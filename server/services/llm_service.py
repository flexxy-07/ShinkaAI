from google import genai
from config import Settings

settings = Settings()


class LLMService:
    def __init__(self):
        self.client = genai.Client(api_key=settings.GEMINI_API_KEY)

    def generate_response(self, query: str, search_results: list[dict]):
        # Build context
        context_text = '\n\n'.join([
            f"Source {idx+1} : {result['url']} \n {result['content']}"
            for idx, result in enumerate(search_results)
        ])

        full_prompt = f"""
Context from web search results :
{context_text}

Query : {query}

Please provide a comprehensive, detailed, well-cited response using the above context. Think and reason deeply. Ensure it answers the query the user is asking. Do not use your knowledge until absolutely necessary.
"""

        try:
            response = self.client.models.generate_content(
                model="gemini-2.5-flash",  # stable + fast
                contents=full_prompt
            )

            # Simulate streaming (since new SDK doesn't stream like old one)
            yield response.text

        except Exception as e:
            print("LLM Error:", str(e))
            yield "Something went wrong while generating response."