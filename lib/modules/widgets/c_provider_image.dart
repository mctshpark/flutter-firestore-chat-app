import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_chat_flutter/routes/app_pages.dart';

class CProviderImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment align;

  const CProviderImage({
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.align = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) {
        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.SlideOutImageView, arguments: {'imageProvider': imageProvider, 'url': url});
          },
          child: Image(
            image: imageProvider,
            fit: fit,
            alignment: align,
            width: width,
            height: height,
          ),
        );
      },
    );
  }
}
