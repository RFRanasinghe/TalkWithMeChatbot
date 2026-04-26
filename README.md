<div align="center">
  <img height="150" src="https://media.giphy.com/media/M9gbBd9nbDrOTu1Mqx/giphy.gif" />
</div>

<div align="center">

# 🤖 GeminiChat — AI Chatbot App

**A Flutter-powered conversational AI assistant driven by Google's Gemini API**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Gemini API](https://img.shields.io/badge/Gemini_API-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://ai.google.dev)
[![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![LinkedIn](https://img.shields.io/static/v1?message=LinkedIn&logo=linkedin&label=&color=0077B5&logoColor=white&labelColor=&style=for-the-badge)](https://www.linkedin.com/in/sewminiranasinghe/)

</div>

---

## 📌 Project Overview

GeminiChat is a **real-time AI chatbot mobile application** built with Flutter that leverages Google's **Gemini Generative Language API** to deliver intelligent, context-aware conversational responses. Users can interact with the AI directly through a clean chat interface — just type and get instant AI-powered replies.

> **In short:** You type → Gemini thinks → You get a smart answer. All inside a Flutter app.

---

## ✨ Key Features

| Feature | Description |
|---|---|
| 💬 Real-time Chat | Instant message exchange with an AI bot |
| 🧠 Gemini AI Backend | Powered by Google's state-of-the-art generative model |
| 📱 Cross-platform | Runs on Android & iOS via Flutter |
| ⚡ Reactive UI | Chat list rebuilds automatically on new messages |
| 🔌 API Integration | Direct connection to Generative Language API |

---

## 🏗️ Tech Stack

```
┌─────────────────────────────────────────────┐
│               FRONTEND (Client)             │
│           Flutter Framework (Dart)          │
└──────────────────┬──────────────────────────┘
                   │  HTTP Request
┌──────────────────▼──────────────────────────┐
│               BACKEND (API Layer)           │
│           FastAPI (Python Server)           │
└──────────────────┬──────────────────────────┘
                   │  API Call
┌──────────────────▼──────────────────────────┐
│             AI ENGINE                       │
│        Google Gemini API                    │
│  (Generative Language API - Google Cloud)   │
└─────────────────────────────────────────────┘
```

---

## 🔁 Data Flow

> How a message travels from your screen to Gemini and back:

```
User types message
        │
        ▼
_sendMessage() called
        │
        ▼
Message added to _messages list  ──▶  UI updates (chat bubble appears)
        │
        ▼
Sent to Gemini API via model.generateContent()
        │
        ▼
Response received from Gemini
        │
        ▼
Response added to _messages list as "bot"
        │
        ▼
UI rebuilds — reply appears in chat ✅
```

---

## 🔑 API Setup — Enable the Generative Language API

> ⚠️ **This step is required before running the app.** The Gemini API must be enabled in your Google Cloud project for the chatbot to function.

### Step-by-step:

1. **Go to Google Cloud Console:**
   👉 [Enable Generative Language API](https://console.cloud.google.com/apis/library/generativelanguage.googleapis.com?project=curious-clone-494506-k9)

2. **Click "Enable"** on the API library page.

3. **Generate an API Key:**
   - Navigate to **APIs & Services → Credentials**
   - Click **Create Credentials → API Key**
   - Copy the key

4. **Add the key to your project:**
   ```dart
   // In your Flutter project config or .env
   const String geminiApiKey = "YOUR_API_KEY_HERE";
   ```

> 💡 Never commit your API key to version control. Use environment variables or a secrets manager.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed
- Dart SDK (comes with Flutter)
- A Google Cloud account with billing enabled
- Gemini API key (see API Setup above)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/sewminiranasinghe/geminichat.git
cd geminichat

# 2. Install dependencies
flutter pub get

# 3. Add your Gemini API key to the project
#    (see API Setup section above)

# 4. Run the app
flutter run
```

---

## 📂 Project Structure

```
lib/
├── main.dart               # App entry point
├── screens/
│   └── chat_screen.dart    # Main chat UI
├── models/
│   └── message.dart        # Message data model
├── services/
│   └── gemini_service.dart # Gemini API integration
└── widgets/
    └── chat_bubble.dart    # Individual message bubble
```

---

## 🛠️ Languages & Tools

<div align="left">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg" height="40" alt="flutter" title="Flutter" />
  &nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg" height="40" alt="dart" title="Dart" />
  &nbsp;&nbsp;
  <img src="https://skillicons.dev/icons?i=fastapi" height="40" alt="fastapi" title="FastAPI" />
  &nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg" height="40" alt="github" title="GitHub" />
  &nbsp;&nbsp;
  <img src="https://skillicons.dev/icons?i=gcp" height="40" alt="gcp" title="Google Cloud" />
</div>

---

## 🧩 How It Works — Core Logic

```dart
// Simplified core message handler
Future<void> _sendMessage(String userInput) async {
  // 1. Add user message to UI
  setState(() {
    _messages.add(Message(role: "user", text: userInput));
  });

  // 2. Call Gemini API
  final response = await model.generateContent([Content.text(userInput)]);

  // 3. Add bot response to UI
  setState(() {
    _messages.add(Message(role: "bot", text: response.text ?? "..."));
  });
}
```

---

## 📋 Deliverables Summary

| Layer | Technology | Purpose |
|---|---|---|
| **Output** | Online Chatbot UI | Conversational interface for users |
| **Frontend** | Flutter Framework | Cross-platform mobile app |
| **Backend / AI** | Google Gemini API | Generates intelligent responses |

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<div align="center">
  <sub>Built with ❤️ by <a href="https://www.linkedin.com/in/sewminiranasinghe/">Sewmini Ranasinghe</a></sub>
</div>
