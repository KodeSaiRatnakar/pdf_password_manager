import 'dart:io';

import 'package:dart_pdf_reader/dart_pdf_reader_io.dart';
// import 'pdf_password_manager_platform_interface.dart';

class PdfPasswordManager {
  Future<bool?> isPasswordProtected(String filePath) async {
    try {
      final file = File(filePath);
      final stream = FileStream(file.openSync());
      final parser = PDFParser(stream);
      final document = await parser.parse();
      final mainTrailer = document.mainTrailer;

      final list = mainTrailer.entries.entries
          .toList()
          .map(
            (e) => e.key.value,
          )
          .toSet();
      return list.contains("Encrypt");
    } catch (e) {
      return true;
    }
  }

  Future<String?> setPassword({
    required String inputPath,
    required String outputPath,
    required String password,
  }) async {
    return null;
    // return await PdfPasswordManagerPlatform.instance.setPassword(
    //   inputPath,
    //   outputPath,
    //   password,
    // );
  }

  Future<String?> removePassword({
    required String inputPath,
    required String outputPath,
    required String password,
  }) async {
    return null;
    // return await PdfPasswordManagerPlatform.instance.removePassword(
    //   inputPath,
    //   outputPath,
    //   password,
    // );
  }
}
