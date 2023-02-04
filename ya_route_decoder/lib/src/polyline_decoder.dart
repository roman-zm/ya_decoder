import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:ya_route_decoder/src/ext/partition.dart';

class YandexPolylineDecoder {
  const YandexPolylineDecoder();

  List<List<double>> decode(String encoded) {
    final pairs = Base64Codec.urlSafe()
        .decode(encoded)
        .partition(8)
        .map((e) => e.partition(4));

    final List<List<int>> coordinates = [];
    for (var pair in pairs) {
      final first = _bytesToInt32(pair.first.reversed);
      final second = _bytesToInt32(pair.last.reversed);

      final lastCoordinate = coordinates.lastOrNull;

      final lat = first + (lastCoordinate?.first ?? 0);
      final lon = second + (lastCoordinate?.last ?? 0);

      coordinates.add([lat, lon]);
    }

    return coordinates
        .map(
          (coordinate) => [
            coordinate.first / 1000000,
            coordinate.last / 1000000,
          ],
        )
        .toList();
  }

  int _bytesToInt32(Iterable<int> bytes) {
    final uint8List = Uint8List.fromList(bytes.toList());
    return ByteData.view(uint8List.buffer).getInt32(0);
  }
}
