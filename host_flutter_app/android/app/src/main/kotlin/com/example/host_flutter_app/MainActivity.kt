package com.example.host_flutter_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example/aar_channel"
    private val AAR_ORIGIN_PREFIX = "[JODETX_ORIGIN]" // ✅ For validation only

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "sendToHost") {
                val message = call.argument<String>("message") ?: ""
                
                if (message.startsWith(AAR_ORIGIN_PREFIX)) {
                    println("✅ Verified AAR message: $message")
                    result.success("Digu: Trusted AAR message received -> $message")
                } else {
                    println("❌ Rejected unverified message: $message")
                    result.error("UNTRUSTED", "Message origin could not be verified", null)
                }
            }
        }
    }
}
