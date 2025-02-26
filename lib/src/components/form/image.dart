import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../../../shadcn_flutter.dart';

enum ImageType { png, jpg, gif, bmp, tiff, tga, pvr, ico }

Future<Uint8List?> applyImageProperties(
    Uint8List list, ImageProperties props, ImageType type) async {
  final cmd = img.Command()..decodeImage(list);
  if (props.flipHorizontal) {
    cmd.flip(direction: img.FlipDirection.horizontal);
  }
  if (props.flipVertical) {
    cmd.flip(direction: img.FlipDirection.vertical);
  }
  if (props.rotation != 0) {
    cmd.copyRotate(angle: props.rotation);
  }
  var cropRect = props.cropRect;
  if (cropRect != Rect.zero) {
    cmd.copyCrop(
      x: cropRect.left.toInt(),
      y: cropRect.top.toInt(),
      width: cropRect.width.toInt(),
      height: cropRect.height.toInt(),
    );
  }
  switch (type) {
    case ImageType.png:
      cmd.encodePng();
      break;
    case ImageType.jpg:
      cmd.encodeJpg();
      break;
    case ImageType.gif:
      cmd.encodeGif();
      break;
    case ImageType.bmp:
      cmd.encodeBmp();
      break;
    case ImageType.tiff:
      cmd.encodeTiff();
      break;
    case ImageType.tga:
      cmd.encodeTga();
      break;
    case ImageType.pvr:
      cmd.encodePvr();
      break;
    case ImageType.ico:
      cmd.encodeIco();
      break;
  }
  var result = await cmd.executeThread();
  return result.outputBytes;
}

class ImageProperties {
  final Rect cropRect;
  final double rotation;
  final bool flipHorizontal;
  final bool flipVertical;

  const ImageProperties({
    this.cropRect = Rect.zero,
    this.rotation = 0,
    this.flipHorizontal = false,
    this.flipVertical = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageProperties &&
        other.cropRect == cropRect &&
        other.rotation == rotation &&
        other.flipHorizontal == flipHorizontal &&
        other.flipVertical == flipVertical;
  }

  @override
  int get hashCode => Object.hash(cropRect, rotation, flipHorizontal, flipVertical);

  @override
  String toString() =>
      'ImageProperties(cropRect: $cropRect, rotation: $rotation, flipHorizontal: $flipHorizontal, flipVertical: $flipVertical)';

  ImageProperties copyWith({
    Rect? cropRect,
    double? rotation,
    bool? flipHorizontal,
    bool? flipVertical,
  }) {
    return ImageProperties(
      cropRect: cropRect ?? this.cropRect,
      rotation: rotation ?? this.rotation,
      flipHorizontal: flipHorizontal ?? this.flipHorizontal,
      flipVertical: flipVertical ?? this.flipVertical,
    );
  }
}

class ImageInput extends StatelessWidget {
  final List<XFile> images;
  final ValueChanged<List<XFile>> onChanged;
  final VoidCallback? onAdd;
  final bool canDrop;

  const ImageInput({
    super.key,
    required this.images,
    required this.onChanged,
    this.onAdd,
    this.canDrop = true,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class ImageTools extends StatelessWidget {
  final Widget image;
  final ImageProperties properties;
  final ValueChanged<ImageProperties> onPropertiesChanged;

  const ImageTools({
    super.key,
    required this.image,
    required this.properties,
    required this.onPropertiesChanged,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
