class EncodedRouteExtractor {
  List<String> extract(String source) {
    const searchKey = '"encodedCoordinates":"';

    var startPos = 0;

    final routes = <String>[];

    while (startPos >= 0) {
      startPos = source.indexOf(searchKey, startPos);

      if (startPos > 0) {
        final start = startPos + searchKey.length;
        final end = source.indexOf('"', startPos + searchKey.length);

        startPos = end;

        final route = source.substring(start, end);
        routes.add(route);
      }
    }

    return routes;
  }
}
