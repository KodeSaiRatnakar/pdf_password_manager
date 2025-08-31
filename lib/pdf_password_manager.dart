import 'dart:io';

import 'package:dart_pdf_reader/dart_pdf_reader_io.dart';
// import 'pdf_password_manager_platform_interface.dart';

class PdfPasswordManager {
  Future<bool?> isPasswordProtected(String filePath) async {
    try {
      final file = File(filePath);
      final raf = file.openSync();

      // Go near the end of the file (where trailer usually is)
      final length = raf.lengthSync();
      final readSize = 2048; // read last 2 KB (enough for trailer)
      final start = length > readSize ? length - readSize : 0;
      raf.setPositionSync(start);

      final data = raf.readSync(readSize);
      final content = String.fromCharCodes(data);
      raf.closeSync();
      return content.contains("/Encrypt");
    } catch (e) {
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
