from fastapi import APIRouter, Request, Response
from twilio.twiml.voice_response import VoiceResponse, Gather
import os
import google.generativeai as genai

router = APIRouter()

# Initialize Gemini
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
model = genai.GenerativeModel('gemini-1.5-flash')

@router.post("/incoming")
async def handle_incoming_call(request: Request):
    response = VoiceResponse()
    response.say("Voice AI activated. What is your question?", voice='Polly.Amy')
    gather = Gather(input='speech', action='/api/voice/process', timeout=5)
    response.append(gather)
    return Response(content=str(response), media_type="application/xml")

@router.post("/process")
async def process_voice_input(request: Request):
    form_data = await request.form()
    user_speech = form_data.get("SpeechResult", "")
    response = VoiceResponse()
    if user_speech:
        prompt = f"Give a brief response to: '{user_speech}'"
        try:
            ai_response = model.generate_content(prompt)
            text = ai_response.text.strip()
        except:
            text = "Error connecting to AI."
        response.say(text, voice='Polly.Amy')
    else:
        response.say("Goodbye.")
    return Response(content=str(response), media_type="application/xml")
