# TalkToAI: Garmin + Gemini (Developer Approach)

This is a professional two-part system that allows you to talk to Gemini AI directly from your Garmin watch using your iPhone as a bridge.

## 🚀 How it Works
1.  **Garmin Watch**: Acts as a BLE (Bluetooth Low Energy) peripheral. When you press the "Ask Gemini" button, it notifies your iPhone.
2.  **iOS App**: A background-enabled Swift app that listens for the watch. It automatically routes audio through the watch's speaker and microphone using the **Bluetooth Headset Profile (HFP)**.
3.  **Gemini AI**: The iPhone app records your voice, sends it to Gemini 1.5 Flash, and plays the audio response back through your watch.

## 📁 Project Structure
- **/ios**: The Xcode project for the iPhone companion app.
  - `BLEManager.swift`: Handles background connection to the watch.
  - `AudioManager.swift`: Handles voice recording and HFP routing.
  - `GeminiService.swift`: Handles the AI interaction.
- **/garmin**: The Monkey C source code for the Connect IQ app.
  - `VoiceAIDelegate.mc`: The logic for BLE advertising and triggering the phone.

## 🛠 Setup & Deployment
1.  **Gemini API**: Get your key from [Google AI Studio](https://aistudio.google.com/) and paste it into `GeminiService.swift`.
2.  **iOS App**: Open `/ios/TalkToAI` in Xcode. Enable "Background Modes" (Bluetooth LE accessories) in the project settings.
3.  **Garmin App**: Import `VoiceAIDelegate.mc` into your Connect IQ project to enable the "TalkToAI" trigger.

Built for Fenix 8 and newer Garmin watches with built-in speakers and microphones.
