import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImageService {
  static final _picker = ImagePicker();

  static Future<String?> pickAndConvertToBase64(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return null;

      final File file = File(pickedFile.path);

      final File compressed = await compressImage(file);

      final bytes = await compressed.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }

  static Future<File> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = join(
      dir.path,
      "${DateTime.now().millisecondsSinceEpoch}.jpg",
    );

    final File? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
    );

    return result ?? file;
  }
}
