part of google_maps_flutter_web;

/// This wraps a [TileOverlay] in a [gmaps.MapType].
class TileOverlayController {
  /// For consistency with Android, this is not configurable.
  // TODO(AsturaPhoenix): Verify consistency with iOS.
  static const int logicalTileSize = 256;

  /// Updates the [gmaps.MapType] and cached properties with an updated
  /// [TileOverlay].
  void update(TileOverlay tileOverlay) {
    _tileOverlay = tileOverlay;
    _gmMapType = gmaps.MapType()
      ..tileSize = gmaps.Size(logicalTileSize, logicalTileSize)
      ..getTile = _getTile;
  }

  HtmlElement? _getTile(
      gmaps.Point? tileCoord, num? zoom, Document? ownerDocument) {
    if (_tileOverlay.tileProvider == null) {
      return null;
    }

    final DivElement div = ownerDocument!.createElement('div') as DivElement;
    _tileOverlay.tileProvider!
        .getTile(tileCoord!.x!.toInt(), tileCoord.y!.toInt(), zoom?.toInt())
        .then((Tile tile) async {
      if (tile is ImageTile && tile.image is WebImage) {
        final canvas = (tile.image as WebImage).source as Element;
        canvas.style.width = canvas.style.height = '${logicalTileSize}px';
        div.children = [canvas];
      } else {
        final encoded = await tile.asEncodedTile();
        if (encoded.data == null) {
          return;
        }

        // Using img lets us take advantage of native decoding.
        final img = ownerDocument.createElement('img') as ImageElement;
        img.width = img.height = logicalTileSize;
        final String src = Url.createObjectUrl(Blob(<dynamic>[encoded.data]));
        img.src = src;
        await img.decode();
        div.children = [img];
        Url.revokeObjectUrl(src);
      }
    });
    return div;
  }

  /// The [gmaps.MapType] produced by this controller.
  gmaps.MapType get gmMapType => _gmMapType;
  late gmaps.MapType _gmMapType;

  /// The [TileOverlay] providing data for this controller.
  TileOverlay get tileOverlay => _tileOverlay;
  late TileOverlay _tileOverlay;
}
