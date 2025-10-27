import 'dart:io';
import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareImage(File imageFile) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(imageFile.path)],
          title: 'Ma citation personnalisée',
        ),
      );
    } catch (e) {
      print('Error sharing image: $e');
    }
  }

  Future<void> shareText(String text) async {
    try {
      await SharePlus.instance.share(ShareParams(text: text));
    } catch (e) {
      print('Error sharing text: $e');
    }
  }
}
