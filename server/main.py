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
@app.websocket('/ws/chat')
async def websocket_chat_endpoint(websocket : WebSocket):
        print('Websocket connection attempted')
        await websocket.accept()
        print('Websocket connection accepted ✅✅✅')
        
        try:
                await asyncio.sleep(0.1)
                print('Waiting for data from client...')
                data = await websocket.receive_json()
                print(f'Data received from client: {data}✅')
                query = data.get('query')
                print('Attempting to search the web for query:')
                search_results = search_service.web_search(query)
                print(f'Search results obtained✅')
                sorted_results = sort_source_service.sort_sources(query, search_results)
                print(f'Search results sorted✅')
                # sending intermediate response to the client
                await asyncio.sleep(0.1)
                await websocket.send_json({
                        'type' : 'search_results',
                        'data' : sorted_results
                })
                print(f'Intermediate response sent to client✅')
                for chunk in llm_service.generate_response(query, sorted_results):
                        await asyncio.sleep(0.1)
                        await websocket.send_json({
                                'type' : 'content',
                                'data' : chunk
                        })
        except Exception as e:
                print(f'Unexpected error in websocket connection: {e}')
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