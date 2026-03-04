import asyncio

from fastapi import FastAPI, WebSocket
from pydantic_models.chat_body import ChatBody
from services.llm_service import LLMService
from services.sort_source_service import SortSourceService
from services.search_service import SearchService

app = FastAPI()

search_service = SearchService()  
sort_source_service = SortSourceService()
llm_service = LLMService()

# web sockets
@app.websocket('ws/chat')
async def websocket_chat_endpoint(websocket : WebSocket):
        await websocket.accept()
        
        try:
                await asyncio.sleep(0.1)
                data = await websocket.receive_json()
                query = data.get('query')
                search_results = search_service.web_search(query)
                sorted_results = sort_source_service.sort_sources(query, search_results)
                # sending intermediate response to the client
                await asyncio.sleep(0.1)
                await websocket.send_json({
                        'type' : 'search_results',
                        'data' : sorted_results
                })
                
                for chunk in llm_service.generate_response(query, sorted_results):
                        await asyncio.sleep(0.1)
                        await websocket.send_json({
                                'type' : 'content',
                                'data' : chunk
                        })
        except:
                print('Unexpected error in websocket connection')
        finally:
                await websocket.close()
        



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