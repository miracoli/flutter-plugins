// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart' show immutable;
import 'package:image/image.dart' as img;

/// Contains information about a Tile that is returned by a [TileProvider].
@immutable
abstract class Tile {
  factory Tile(int width, int height, Uint8List? data) =>
      EncodedTile(width, height, data);

  int get width;
  int get height;

  Future<EncodedTile> asEncodedTile();
}

@immutable
class EncodedTile implements Tile {
  /// Creates an immutable representation of a [Tile] to draw by [TileProvider].
  const EncodedTile(this.width, this.height, this.data);

  /// The width of the image encoded by data in logical pixels.
  final int width;

  /// The height of the image encoded by data in logical pixels.
  final int height;

  /// A byte array containing the image data.
  ///
  /// The image data format must be natively supported for decoding by the platform.
  /// e.g on Android it can only be one of the [supported image formats for decoding](https://developer.android.com/guide/topics/media/media-formats#image-formats).
  final Uint8List? data;

  /// Converts this object to JSON.
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('width', width);
    addIfPresent('height', height);
    addIfPresent('data', data);

    return json;
  }

  @override
  asEncodedTile() async => this;
}

class ImageTile implements Tile {
  static final _encoder = img.BmpEncoder();

  ImageTile(this.image);
  final Image image;

  @override
  get width => image.width;
  @override
  get height => image.height;

  @override
  Future<EncodedTile> asEncodedTile() async {
    final data =
        await image.toByteData(format: ImageByteFormat.rawStraightRgba);
    final imgImage =
        img.Image.fromBytes(width, height, data!.buffer.asUint8List());
    final encoded = EncodedTile(
        width, height, Uint8List.fromList(_encoder.encodeImage(imgImage)));
    // TODO: This is obviously nonobvious and we should make things clearer to move this out of prototype.
    image.dispose();
    return encoded;
  }
}
