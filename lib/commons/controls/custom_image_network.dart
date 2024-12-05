import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:DigiRestro/utils/asset_manager.dart';

class CustomImageNetwork extends StatelessWidget {
  const CustomImageNetwork({
    Key? key,
    required this.imageUrl,
    required this.boxFit,
    required this.height,
    required this.width,
    this.color,
    this.blendMode,
    this.errorWidget,
  }) : super(key: key);
  final String imageUrl;
  final BoxFit boxFit;
  final double height;
  final double width;
  final Color? color;
  final Widget? errorWidget;
  final BlendMode? blendMode;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl, //const Color.fromRGBO(0, 0, 0, 0.2),
      fit: boxFit,
      height: height,
      width: width,
      color: color, // Adjust the last value (opacity) as needed
      colorBlendMode: blendMode,

      placeholder: (context, url) =>
          const SizedBox(), // Placeholder widget while the image is loading
      errorWidget: (context, url, error) =>
          errorWidget ??
          SvgPicture.asset(
            SvgAssets.profilePlaceholder,
            color: Colors.black,
            fit: boxFit,
            height: height,
            width: width,
          ), // Widget to display in case of an error
    );
  }
}
