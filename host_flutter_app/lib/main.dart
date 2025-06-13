import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const DiguHostApp());
}

class DiguHostApp extends StatelessWidget {
  const DiguHostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digu Host App',
      home: DiguCommunicationScreen(),
    );
  }
}

class DiguCommunicationScreen extends StatefulWidget {
  const DiguCommunicationScreen({super.key});

  @override
  State<DiguCommunicationScreen> createState() =>
      _DiguCommunicationScreenState();
}

class _DiguCommunicationScreenState extends State<DiguCommunicationScreen> {
  static const MethodChannel _channel =
      MethodChannel('com.example/aar_channel');

  final TextEditingController _controller = TextEditingController();

  String _sentToHost = '';
  String _receivedFromHost = '';
  String _hostMessageSentToAAR = ''; // Optional: Simulated Host-to-AAR message
  bool _isSending = false;

  Future<void> _sendMessageToHost() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _isSending = true;
      _sentToHost = message;
      _receivedFromHost = '';
    });

    try {
      final response =
          await _channel.invokeMethod('sendToHost', {'message': message});

      setState(() {
        _receivedFromHost = response.toString();
        _hostMessageSentToAAR = "Digu sent acknowledgment to Jodetx (AAR)";
        _isSending = false;
        _controller.clear(); // ✅ Clear after sending
      });
    } catch (e) {
      setState(() {
        _receivedFromHost = "❌ Error: $e";
        _isSending = false;
      });
    }
  }

  Widget buildMessageCard(String title, String content, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 16)),
          const SizedBox(height: 10),
          Text(content, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Digu Host App"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Text input and send button
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Message from Jodetx (AAR)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isSending ? null : _sendMessageToHost,
              icon: const Icon(Icons.send),
              label: _isSending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ))
                  : const Text("Send to Host App"),
            ),

            const SizedBox(height: 30),

            // Sent message from AAR
            if (_sentToHost.isNotEmpty)
              buildMessageCard(
                  "📤 Sent from Jodetx (AAR):", _sentToHost, Colors.blue),

            // Response received from host
            if (_receivedFromHost.isNotEmpty)
              buildMessageCard("📬 Response from Digu (Host App):",
                  _receivedFromHost, Colors.green),

            // Host sends message back to AAR
            if (_hostMessageSentToAAR.isNotEmpty)
              buildMessageCard("📣 Host sent back to AAR:",
                  _hostMessageSentToAAR, Colors.orange),
          ],
        ),
      ),
    );
  }
}
