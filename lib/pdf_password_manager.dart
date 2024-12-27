// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'pdf_password_manager_platform_interface.dart';

class PdfPasswordManager {
  Future<bool?> isPasswordProtected(String inputPath) async {
    return await PdfPasswordManagerPlatform.instance.isPasswordProtected(
      inputPath,
    );
  }

  Future<void> setPassword({
    required String inputPath,
    required String outputPath,
    required String password,
  }) async {
    return await PdfPasswordManagerPlatform.instance.setPassword(
      inputPath,
      outputPath,
      password,
    );
  }

  Future<void> removePassword({
    required String inputPath,
    required String outputPath,
    required String password,
  }) async {
    return await PdfPasswordManagerPlatform.instance.removePassword(
      inputPath,
      outputPath,
      password,
    );
  }
}
