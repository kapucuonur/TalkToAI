from fastapi import FastAPI
from backend.routers import voice
from dotenv import load_dotenv
import uvicorn

load_dotenv()
app = FastAPI()

app.include_router(voice.router, prefix="/api/voice")

@app.get("/")
async def root():
    return {"message": "TalkToAI Backend Running"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
