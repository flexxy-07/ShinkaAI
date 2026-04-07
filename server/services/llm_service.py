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
                model="gemini-2.5-flash-lite",
                contents=full_prompt
            )


            if response and response.text:
                yield response.text
            else:
                yield "The AI returned an empty response. Please try a different query."

        except Exception as e:
            error_msg = str(e).lower()
            if "429" in error_msg or "quota" in error_msg:
                yield "⚠️ Gemini API Quota Exceeded. Please wait a minute before trying again or switch to a paid API key for higher limits."
            else:
                import traceback
                traceback.print_exc()
                print("LLM Error:", str(e))
                yield f"Something went wrong while generating response. Error details: {str(e)}"
