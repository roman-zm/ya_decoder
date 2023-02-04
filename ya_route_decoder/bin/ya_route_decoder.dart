import 'dart:io';

import 'package:ya_route_decoder/ya_route_decoder.dart';

void main(List<String> arguments) async {
  final url = Uri.parse(arguments.first).toString();
  // 'https://yandex.ru/maps/213/moscow/?ll=37.615270%2C55.626670&mode=routes&rtext=55.629299%2C37.613571~55.722233%2C37.977518&rtt=auto&ruri=~ymapsbm1%3A%2F%2Fgeo%3Fdata%3DCgoxOTI4NDYxODExEpYB0KDQvtGB0YHQuNGPLCDQnNC%2B0YHQutC%2B0LLRgdC60LDRjyDQvtCx0LvQsNGB0YLRjCwg0JHQsNC70LDRiNC40YXQsCwg0LzQuNC60YDQvtGA0LDQudC%2B0L0g0J3QvtCy0L7QtSDQn9Cw0LLQu9C40L3Qviwg0YPQu9C40YbQsCDQkdC%2B0Y%2FRgNC40L3QvtCy0LAsIDExIgoN%2BugXQhWR415C&z=15.42';

  final gpxStrings = await decode(url);

  for (var i = 0; i < gpxStrings.length; i++) {
    final gpx = gpxStrings[i];

    File('out/${DateTime.now().toIso8601String()}_$i.gpx')
        .writeAsStringSync(gpx);
  }
}
