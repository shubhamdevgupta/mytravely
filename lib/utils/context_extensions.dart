import 'package:flutter/widgets.dart';

extension ContextExt on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);

  Size get screenSize => mq.size;
  double get screenWidth => mq.size.width;
  double get screenHeight => mq.size.height;

  EdgeInsets get safePadding => mq.padding;
  double get topSafe => mq.padding.top;
  double get bottomSafe => mq.padding.bottom;

  bool get isPortrait => mq.orientation == Orientation.portrait;
  bool get isLandscape => mq.orientation == Orientation.landscape;
}


