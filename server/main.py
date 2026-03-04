from fastapi import FastAPI
from pydantic_models.chat_body import ChatBody
from services.llm_service import LLMService
from services.sort_source_service import SortSourceService
from services.search_service import SearchService

app = FastAPI()

search_service = SearchService()  
sort_source_service = SortSourceService()
llm_service = LLMService()

@app.post("/chat")
def chat_endpoint(body : ChatBody):
    # Steps -> 1. Get the query from the body
    #          2. Search the web and find appropriate results
    search_results = search_service.web_search(body.query)
            #  3. Sort the responses on the basis of relevance
    sorted_results = sort_source_service.sort_sources(body.query, search_results)
              # 4. Generate the response using LLM(In out Case Gemini)
    response = llm_service.generate_response(body.query, sorted_results)
    print(response)
    return response