# ShinkaAI

ShinkaAI is an AI-powered search application inspired by tools like Perplexity.  
It combines real-time web search with large language models to generate answers along with relevant sources.

The application searches the web, ranks sources based on semantic relevance, and generates a structured AI response that is streamed back to the user interface.

---

## Features

- AI-generated answers using **Gemini**
- **Real-time streaming responses** with WebSockets
- **Web search integration** using Tavily API
- **Source ranking** using sentence embeddings
- **Markdown rendering** for structured responses
- Displays **relevant sources alongside answers**

---

## Tech Stack

**Frontend**
- Flutter
- Dart

**Backend**
- FastAPI
- Python
- WebSockets

**AI & Search**
- Google Gemini API
- Tavily Search API
- Sentence Transformers

---

## Architecture
User Query
↓
Flutter Frontend
↓
WebSocket
↓
FastAPI Backend
↓
Web Search (Tavily)
↓
Source Ranking
↓
Gemini LLM
↓
Streaming Response


---

## Running the Project

### Backend


cd server
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
fastapi dev main.py


Backend runs at:





---

### Frontend


cd client
flutter pub get
flutter run


---

## Future Improvements

This project is still under development. More features and improvements will be added in the future, including:

- Better UI and responsiveness
- Conversation memory
- Improved ranking and search
- Source previews
- Additional AI features

---

## Inspiration

Inspired by modern AI search engines like **Perplexity AI**.
