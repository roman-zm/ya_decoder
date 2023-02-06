import 'package:gpx/gpx.dart';

class GpxCreator {
  const GpxCreator();

  String generateGpxString(List<List<double>> locations, String name) {
    final gpx = Gpx();

    final Trkseg trackSegment = Trkseg(
      trkpts: locations.map((l) => Wpt(lat: l.last, lon: l.first)).toList(),
    );

    gpx.trks = [
      Trk(
        name: name,
        trksegs: [trackSegment],
      ),
    ];

    return GpxWriter().asString(gpx, pretty: true);
  }
}
