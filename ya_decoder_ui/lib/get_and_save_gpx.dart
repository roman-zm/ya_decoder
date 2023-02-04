import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:ya_route_decoder/ya_route_decoder.dart';

Future getGpx(String url) async {
  final gpxStrings = await decode(url);

  final dirPath = await FilePicker.platform.getDirectoryPath(
    dialogTitle: 'Куда сохранить',
    lockParentWindow: true,
  );
  final now = DateTime.now().toIso8601String();

  if (dirPath != null) {
    for (var i = 0; i < gpxStrings.length; i++) {
      try {
        final separator = Platform.pathSeparator;
        final fileName = '${now}_$i.gpx';
        await File('$dirPath$separator$fileName').writeAsString(gpxStrings[i]);
      } catch (e) {
        throw YaDecoderError('Ошибка при сохранении файлов: $e');
      }
    }
  }
}
