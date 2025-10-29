import 'package:flutter/material.dart';

class UiUtils {
  UiUtils._();

  static const double cardRadius = 12.0;
  static const double smallGap = 8.0;
  static const double normalGap = 16.0;
  static const double largeGap = 24.0;

  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(cardRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        )
      ],
    );
  }

  static Widget safeNetworkImage(String? url, {double? width, double? height, BorderRadius? radius}) {
    final placeholder = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: radius,
      ),
      child: const Icon(Icons.image, color: Colors.grey),
    );

    if (url == null || url.isEmpty) return placeholder;

    final image = Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );

    return radius != null
        ? ClipRRect(borderRadius: radius, child: image)
        : image;
  }
}


