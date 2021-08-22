import 'package:open_chat_flutter/utils/base_view_import.dart';

class RoundBox extends StatelessWidget {
  final double radius;
  final double? width;
  final double height;
  final Widget? child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final Color? color;

  const RoundBox({
    Key? key,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.radius = 10,
    this.height = 50,
    this.width,
    this.child,
    this.border,
    this.onTap,
    this.boxShadow,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (width != null) {
      result = Container(
        margin: margin,
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: boxShadow,
          color: color ?? cBlack02,
          border: border ?? const Border(),
        ),
        child: child ?? Container(),
      );
    } else {
      result = Container(
        margin: margin,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: boxShadow,
          border: border ?? const Border(),
          color: color ?? cBlack02,
        ),
        child: child ?? Container(),
      );
    }

    if (onTap != null) {
      result = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: result,
      );
    }

    return result;
  }
}
