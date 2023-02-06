import 'dart:async';

import 'package:puppeteer/puppeteer.dart';
import 'package:ya_route_decoder/ya_route_decoder.dart';

class BrowserFetcher {
  Future<String> fetch(String url) async {
    final completer = Completer();
    final browser = await puppeteer.launch(headless: false);

    try {
      final page = await browser.newPage();

      final urlParams = _extractUrlParams(url);
      page.onResponse.listen((event) async {
        if (event.url.contains(urlParams)) {
          try {
            final content = await event.content;
            browser.close();
            completer.complete(content.toString());
          } catch (e) {
            print(e);
          }
        }
      });
      page.goto(url);
      page.onClose.then((value) {
        browser.close();
        completer.complete();
        throw YaDecoderError('Браузер закрыт');
      });
    } catch (e) {
      await browser.close();
      throw YaDecoderError('Ошибка при работе с бразуером');
    }

    return await completer.future;
  }

  String _extractUrlParams(String url) {
    final index = url.indexOf('?');
    return url.substring(index);
  }
}
