import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageService {
  final SupabaseClient supabase = Supabase.instance.client;

    final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return null;
    return File(picked.path);
  }

  Future<String?> uploadImage(File file, String userId) async {
    try {
      final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      final filePath = "vehicle-images2/$userId/$fileName";

      final bytes = await file.readAsBytes();

      final res = await supabase.storage
          .from("vehicle-images2")
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(
              contentType: "image/jpeg",
              upsert: true,
            ),
          );

      if (res.isEmpty) return null;

      return supabase.storage.from("vehicle-images2").getPublicUrl(filePath);
    } catch (e) {
      print("IMAGE UPLOAD ERROR: $e");
      return null;
    }
  }

  // Future<Future<String?>> uploadImage(File file, String fileName) async {}
}
