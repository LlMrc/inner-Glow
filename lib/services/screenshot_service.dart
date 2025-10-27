import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class ScreenshotService {
  final ScreenshotController controller = ScreenshotController();

  Future<File?> captureAndSave() async {
    try {
      final image = await controller.capture();
      if (image == null) return null;

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/citation.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      return imageFile;
    } catch (e) {
      print('Error capturing screenshot: $e');
      return null;
    }
  }
}