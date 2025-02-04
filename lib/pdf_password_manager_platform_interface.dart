import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pdf_password_manager_method_channel.dart';

abstract class PdfPasswordManagerPlatform extends PlatformInterface {
  /// Constructs a PdfPasswordManagerPlatform.
  PdfPasswordManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static PdfPasswordManagerPlatform _instance =
      MethodChannelPdfPasswordManager();

  /// The default instance of [PdfPasswordManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelPdfPasswordManager].
  static PdfPasswordManagerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PdfPasswordManagerPlatform] when
  /// they register themselves.
  static set instance(PdfPasswordManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> isPasswordProtected(String inputPath);

  Future<String?> setPassword(
    String inputPath,
    String outputPath,
    String password,
  );

  Future<String?> removePassword(
    String inputPath,
    String outputPath,
    String password,
  );
}
