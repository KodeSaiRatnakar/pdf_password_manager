import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf_password_manager/pdf_password_manager.dart';
import 'package:path/path.dart' as path_controller;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> savePDF({
    required String pdfFileName,
    required File oldPDFFile,
  }) async {
    final selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      String fullPath = path_controller.join(
        selectedDirectory,
        "$pdfFileName.pdf",
      );
      await File(fullPath).writeAsBytes(oldPDFFile.readAsBytesSync());
    }
  }

  Future<String?> selectedPDFFilePath() async {
    final selectedPDFFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    return selectedPDFFile?.files.first.path;
  }

  Future<void> addPassword() async {
    final _selectedPDFFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );
    if (_selectedPDFFile?.files.first == null) {
      return;
    }
    final file = _selectedPDFFile?.files.first.xFile;
    if (file == null) return;

    final join = path_controller.join(
      file.path.replaceAll(file.name, ''),
      'protected_with_password.pdf',
    );
    await PdfPasswordManager().setPassword(
      inputPath: file.path,
      outputPath: join,
      password: 'password',
    );

    await savePDF(
      pdfFileName: 'protected_with_password.pdf',
      oldPDFFile: File(join),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF password added'),
      ),
    );
  }

  Future<void> removePassword() async {
    final pdfPath = await selectedPDFFilePath();
    if (pdfPath == null) {
      return;
    }
    final file = File(pdfPath);

    await PdfPasswordManager().removePassword(
      inputPath: pdfPath,
      outputPath: path_controller.join(
        file.parent.path,
        'unprotected.pdf',
      ),
      password: 'password',
    );

    await savePDF(
      pdfFileName: 'unprotected.pdf',
      oldPDFFile: File(
        path_controller.join(
          file.parent.path,
          'unprotected.pdf',
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF password removed'),
      ),
    );
  }

  Future<void> checkPdfHasPassword() async {
    final pdfPath = await selectedPDFFilePath();
    if (pdfPath == null) {
      return;
    }
    bool? isProtected = await PdfPasswordManager().isPasswordProtected(pdfPath);

    if (isProtected == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF has no password'),
        ),
      );
      return;
    } else if (isProtected == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF has password'),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await Permission.manageExternalStorage.request();
              },
              child: const Text('Get File Perimission'),
            ),
            ElevatedButton(
              onPressed: checkPdfHasPassword,
              child: const Text('Check PDF has Password'),
            ),
            ElevatedButton(
              onPressed: addPassword,
              child: const Text('Add Password'),
            ),
            ElevatedButton(
              onPressed: removePassword,
              child: const Text('remove Password'),
            ),
          ],
        ),
      ),
    );
  }
}
