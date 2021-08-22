import 'package:open_chat_flutter/utils/base_view_import.dart';

enum CButtonStyle { basic, outline }

class CButton extends StatelessWidget {
  final CButtonStyle style;
  final double radius;
  final double? width;
  final double? height;
  final Widget? child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;
  final BorderSide? borderSide;
  final Color splashColor;
  final bool isDisabled;

  const CButton({
    Key? key,
    this.style = CButtonStyle.basic,
    this.radius = 4,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.child,
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.color,
    this.borderSide,
    this.splashColor = const Color.fromRGBO(0, 0, 0, 0.12),
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (style == CButtonStyle.basic) {
      return IgnorePointer(
        ignoring: isDisabled,
        child: Container(
          margin: margin,
          width: width,
          height: height,
          child: TextButton(
            style: TextButton.styleFrom(
              primary: splashColor,
              backgroundColor: isDisabled ? colorPrimaryDisabled : color,
              minimumSize: Size(width ?? MediaQuery.of(context).size.width, height ?? 48.h),
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: borderSide ?? BorderSide.none,
              ),
            ),
            key: key,
            onPressed: onTap,
            child: child ?? Container(),
          ),
        ),
      );
    } else if (style == CButtonStyle.outline) {
      return IgnorePointer(
        ignoring: isDisabled,
        child: Container(
          margin: margin,
          width: width,
          height: height,
          child: TextButton(
            style: TextButton.styleFrom(
              primary: cWhite085,
              backgroundColor: isDisabled ? colorPrimaryDisabled : const Color.fromRGBO(0, 0, 0, 0),
              minimumSize: Size(width ?? MediaQuery.of(context).size.width, height ?? 48.h),
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: borderSide ?? BorderSide(width: 1.w, color: Colors.black),
              ),
            ),
            key: key,
            onPressed: onTap,
            child: child ?? Container(),
          ),
        ),
      );
    }
    return Container();
  }
}
