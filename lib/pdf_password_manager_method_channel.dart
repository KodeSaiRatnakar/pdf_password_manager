import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pdf_password_manager_platform_interface.dart';

/// An implementation of [PdfPasswordManagerPlatform] that uses method channels.
class MethodChannelPdfPasswordManager extends PdfPasswordManagerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pdf_password_manager');

  @override
  Future<String?> setPassword(
    String inputPath,
    String outputPath,
    String password,
  ) async {
    return await methodChannel.invokeMethod<String?>('addPassword', {
      'inputPath': inputPath,
      'outputPath': outputPath,
      'password': password,
    });
  }

  @override
  Future<String?> removePassword(
    String inputPath,
    String outputPath,
    String password,
  ) async {
    return await methodChannel.invokeMethod<String?>('removePassword', {
      'inputPath': inputPath,
      'outputPath': outputPath,
      'password': password,
    });
  }

  @override
  Future<bool> isPasswordProtected(String inputPath) async {
    return await methodChannel.invokeMethod('isPasswordProtected', {
      'inputPath': inputPath,
    });
  }
}
