import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Widget? child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final List<BoxShadow>? boxshadow;
  final String? fileImage;
  final String? urlImage;
  final VoidCallback? onTap;

  const UserAvatar({
    Key? key,
    this.size = 50,
    this.backgroundColor = const Color.fromRGBO(158, 158, 158, 1),
    this.child,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.boxshadow,
    this.fileImage,
    this.urlImage,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (urlImage != null) {
      return InkWell(
        onTap: onTap,
        child: Container(
          margin: margin,
          padding: padding,
          width: size,
          height: size,
          decoration: BoxDecoration(boxShadow: boxshadow),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: urlImage!,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => _placeHolder(),
              placeholder: (context, url) => _placeHolder(),
            ),
          ),
        ),
      );
    } else if (fileImage != null && fileImage != '') {
      return InkWell(
        onTap: onTap,
        child: Container(
          margin: margin,
          padding: padding,
          child: ClipOval(
            child: Image(
              image: FileImage(File(fileImage ?? '')),
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    return _placeHolder();
  }

  Widget _placeHolder() {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding,
        width: size,
        height: size,
        decoration: BoxDecoration(boxShadow: boxshadow),
        child: CircleAvatar(),
      ),
    );
  }
}
