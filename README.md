# TalkToAI: Garmin + Gemini Integration

This is the two-part system to talk to Gemini AI from your Garmin watch.

## Structure
- `/backend`: FastAPI server that connects Twilio to Gemini AI.
- `/garmin`: Monkey C code snippet for your Connect IQ app.

## Deployment to Render
1. **GitHub**: Push this folder to a new GitHub repository.
2. **One-Click**: Render will automatically detect the `render.yaml` file.
3. **Env Vars**: In the Render Dashboard, add your `GEMINI_API_KEY`.
4. **URL**: Once deployed, Render will give you a URL (e.g., `https://talk-to-ai.onrender.com`).

## Twilio Setup
Point your Twilio webhook to: `https://your-app.onrender.com/api/voice/incoming`
