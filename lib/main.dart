import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const TalkWithMeApp());
}

class TalkWithMeApp extends StatelessWidget {
  const TalkWithMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talk With Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(Colors.blueGrey.value),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(Colors.blueGrey.value),
          foregroundColor: Colors.white,
        ),
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  static const String _apiKey = 'YOUR_API_KEY_HERE';

  //Initialize Gemini Model (free tier) - use v1 API
  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: _apiKey,
    generationConfig: GenerationConfig(temperature: 0.9),
  );

  //function to send message to Gemini (Backend)
  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": text});
      _isLoading = true;
    });
    _textController.clear();
    _scrollToBottom();

    try {
      //data flow -> flutter > Internet > Gemini API
      final content = [Content.text(text)];
      final response = await model.generateContent(content);

      setState(() {
        _messages.add({
          "sender": "bot",
          "text": response.text ?? "I'm sorry I couldn't understand that",
        });
        _isLoading = false;
      });
    } catch (e) {
      print("Gemini Error: $e");
      debugPrint("Gemini Error: $e");

      setState(() {
        _messages.add({"sender": "bot", "text": "Error : $e"});
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(microseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Lets Talk freely',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUserMessage = message['sender'] == 'user';

                  return _buildChatBubble(message['text']!, isUserMessage);
                },
              ),
            ),

            //loading indicator
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),

            //bottom input bar
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUserMessage) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),

        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blueAccent : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUserMessage ? 16 : 0),
            bottomRight: Radius.circular(isUserMessage ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUserMessage ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Type your message...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onSubmitted: (value) => _sendMessage(),
              ),
            ),
            SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
