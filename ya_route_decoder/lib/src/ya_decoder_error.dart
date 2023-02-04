class YaDecoderError implements Exception {
  final String message;
  final Object? details;

  YaDecoderError(this.message, [this.details]);

  @override
  String toString() {
    return '$message\n$details';
  }
}
