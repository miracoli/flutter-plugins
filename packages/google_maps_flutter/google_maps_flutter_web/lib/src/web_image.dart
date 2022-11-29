part of google_maps_flutter_web;

class WebImage implements ui.Image {
  WebImage(this.source);
  final CanvasImageSource source;

  @override
  int get width => throw UnimplementedError();

  @override
  int get height => throw UnimplementedError();

  @override
  ui.Image clone() {
    throw UnimplementedError();
  }

  @override
  bool get debugDisposed => throw UnimplementedError();

  @override
  List<StackTrace>? debugGetOpenHandleStackTraces() {
    throw UnimplementedError();
  }

  @override
  void dispose() {
    throw UnimplementedError();
  }

  @override
  bool isCloneOf(ui.Image other) {
    throw UnimplementedError();
  }

  @override
  Future<ByteData?> toByteData(
      {ui.ImageByteFormat format = ui.ImageByteFormat.rawRgba}) {
    throw UnimplementedError();
  }
}
