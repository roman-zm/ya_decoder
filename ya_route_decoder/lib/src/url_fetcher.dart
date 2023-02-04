import 'package:dio/dio.dart';

class UrlFetcher {
  Future<String> fetch(String url) async {
    final dio = Dio(BaseOptions(responseType: ResponseType.plain));

    final response = await dio.get(url);
    return response.data.toString();
  }
}
