import 'package:flutter/services.dart';

class AarBridge {
  static const MethodChannel _channel =
      MethodChannel('com.example/aar_channel');

  static const String _signature = "[JODETX_ORIGIN]"; // ✅ Defined in AAR only

  static Future<String> sendMessageToHost(String message) async {
    final signedMessage = "$_signature $message";
    final response = await _channel.invokeMethod('sendToHost', {
      'message': signedMessage,
    });
    return response;
  }

  static void receiveMessageFromHost(String messageFromHost) {
    print("📥 Jodetx received message from Host: $messageFromHost");
  }
}
