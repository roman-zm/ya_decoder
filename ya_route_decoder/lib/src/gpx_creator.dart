import 'package:gpx/gpx.dart';

class GpxCreator {
  const GpxCreator();

  String generateGpxString(List<List<double>> locations) {
    final gpx = Gpx();

    final Trkseg trackSegment = Trkseg(
      trkpts: locations.map((l) => Wpt(lat: l.last, lon: l.first)).toList(),
    );

    gpx.trks = [
      Trk(trksegs: [trackSegment]),
    ];

    return GpxWriter().asString(gpx, pretty: true);
  }
}
