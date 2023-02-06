import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:ya_decoder_ui/browser_get.dart';
import 'package:ya_route_decoder/ya_route_decoder.dart';

Future getGpx(String url, bool openPageInBrowser) async {
  final gpxStrings = await _getAndDecode(url, openPageInBrowser);

  final dirPath = await FilePicker.platform.getDirectoryPath(
    dialogTitle: 'Куда сохранить',
    lockParentWindow: true,
  );
  final now = DateTime.now();

  if (dirPath != null) {
    for (var i = 0; i < gpxStrings.length; i++) {
      try {
        final separator = Platform.pathSeparator;
        final fileName = _genFileName(now, i);
        final filePath = '$dirPath$separator$fileName';
        final file = File(filePath);
        await file.create();
        await file.writeAsString(gpxStrings[i]);
      } catch (e) {
        throw YaDecoderError('Ошибка при сохранении файлов: $e');
      }
    }
  }
}

Future<List<String>> _getAndDecode(String url, bool openPageInBrowser) async {
  if (openPageInBrowser) {
    try {
      final response = await BrowserFetcher().fetch(url);
      return await decodeResponse(response);
    } on YaDecoderError catch (_) {
      rethrow;
    } catch (e, s) {
      print(s);
      throw YaDecoderError('Ошибка открытия бразуера: $e');
    }
  } else {
    return await decode(url);
  }
}

String _genFileName(DateTime now, int i) {
  return '${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_$i.gpx';
}
