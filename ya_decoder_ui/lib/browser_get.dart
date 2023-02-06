import 'dart:async';

import 'package:puppeteer/puppeteer.dart';
import 'package:ya_route_decoder/ya_route_decoder.dart';

class BrowserFetcher {
  Future<String> fetch(String url) async {
    final completer = Completer();
    final browser = await puppeteer.launch(headless: false);

    try {
      final page = await browser.newPage();

      page.onResponse.listen((event) async {
        if (event.url == url) {
          try {
            final content = await event.content;
            print(content);
            browser.close();
            completer.complete(content.toString());
          } catch (e) {
            // TODO
          }
        }
      });
      page.goto(url);
    } catch (e) {
      await browser.close();
      throw YaDecoderError('Ошибка при работе с бразуером');
    }

    return await completer.future;
  }
}
