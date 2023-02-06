import 'package:dio/dio.dart';
import 'package:ya_route_decoder/src/gpx_creator.dart';
import 'package:ya_route_decoder/src/polyline_decoder.dart';
import 'package:ya_route_decoder/src/url_fetcher.dart';
import 'package:ya_route_decoder/src/ya_decoder_error.dart';
import 'package:ya_route_decoder/src/ya_encoded_route_extractor.dart';

Future<List<String>> decode(String url) async {
  final String response;
  try {
    response = await UrlFetcher().fetch(url);
  } on DioError catch (e) {
    throw YaDecoderError('Ошибка сети: не удалось запросить страницу', e);
  } catch (e) {
    throw YaDecoderError('Ошибка запроса страницы');
  }

  return await decodeResponse(response);
}

Future<List<String>> decodeResponse(String response) async {
  final List<String> encodedRoutes;
  try {
    encodedRoutes = EncodedRouteExtractor().extract(response);
  } catch (e) {
    throw YaDecoderError('Ошибка парсинга страницы', e);
  }

  const polylineDecoder = YandexPolylineDecoder();
  const gpxCreator = GpxCreator();

  final decodedRoutes = <String>[];

  for (var i = 0; i < encodedRoutes.length; i++) {
    final encodedRoute = encodedRoutes[i];

    try {
      final decodedRoute = polylineDecoder.decode(encodedRoute);
      final gpxString = gpxCreator.generateGpxString(decodedRoute);

      decodedRoutes.add(gpxString);
    } catch (_) {}
  }

  if (decodedRoutes.isEmpty) {
    throw YaDecoderError('Маршрутов не найдено');
  } else {
    return decodedRoutes;
  }
}
