package com.example.pdf_password_manager

import androidx.annotation.NonNull
import com.tom_roush.pdfbox.pdmodel.PDDocument
import com.tom_roush.pdfbox.pdmodel.encryption.AccessPermission
import com.tom_roush.pdfbox.pdmodel.encryption.StandardProtectionPolicy
import java.io.File

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** PdfPasswordManagerPlugin */
class PdfPasswordManagerPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pdf_password_manager")
    channel.setMethodCallHandler(this)
  }
override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        val inputPath = call.argument<String>("inputPath")
        val outputPath = call.argument<String>("outputPath")
        val password = call.argument<String>("password")

        try {
            when (call.method) {
                "addPassword" -> {
                    if (inputPath != null && outputPath != null && password != null) {
                        addPassword(inputPath, outputPath, password)
                        result.success("Password added successfully")
                    } else {
                        result.error("INVALID_ARGUMENTS", "Invalid arguments provided", null)
                    }
                }
                "removePassword" -> {
                    if (inputPath != null && outputPath != null && password != null) {
                        removePassword(inputPath, outputPath, password)
                        result.success("Password removed successfully")
                    } else {
                        result.error("INVALID_ARGUMENTS", "Invalid arguments provided", null)
                    }
                }
                "isPasswordProtected" -> {
                    if (inputPath != null) {
                        val isProtected = isPasswordProtected(inputPath)
                        result.success(isProtected)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Invalid arguments provided", null)
                    }
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("ERROR", e.message, null)
        }
    }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

   private fun addPassword(inputPath: String, outputPath: String, password: String) {
        val document = PDDocument.load(File(inputPath))
        val accessPermission = AccessPermission()
        val spp = StandardProtectionPolicy(password, password, accessPermission).apply {
            encryptionKeyLength = 128
            setPermissions(accessPermission)
        }
        document.protect(spp)
        document.save(outputPath)
        document.close()
    }

    private fun removePassword(inputPath: String, outputPath: String, password: String) {
        val document = PDDocument.load(File(inputPath), password)
        document.isAllSecurityToBeRemoved = true
        document.save(outputPath)
        document.close()
    }

    private fun isPasswordProtected(inputPath: String): Boolean {
        return try {
            PDDocument.load(File(inputPath)).use { it.close() }
            false // No password
        } catch (e: com.tom_roush.pdfbox.pdmodel.encryption.InvalidPasswordException) {
            true // Password-protected
        }
    }
}
