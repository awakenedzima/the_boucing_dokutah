import 'dart:ui';
import 'package:flutter/widgets.dart';

import 'math_functions.dart';

class _D {
  bool isDown = true;
  bool isRight = true;
  bool isFirstGenerated = true;
  double y = 0;
  double x = 0;
  double? cx;
  double? cy;
}

/// The coordinates generator object for the bouncing logo.
class BouncingLogoModel {
  double movementAngle;
  double logoWidth;
  final double startX;
  final double startY;
  final _D _prop = _D();

  /// false if the coordinates is left-wise from the previous coordinates
  bool get isRight => _prop.isRight;

  /// false if the coordinates is up-wise from the previous coordinates
  bool get isDown => _prop.isDown;

  BouncingLogoModel({
    required this.movementAngle,
    required this.logoWidth,
    this.startX = 0,
    this.startY = 0,
  }) {
    _prop.x = startX;
    _prop.y = startY;
  }

  /// Generate the logo's coordinates with [Offset] object.
  ///
  /// The generated coordinates is where the logo hits the edge of boundary.
  Offset generate({
    double width = 0,
    double height = 0,
  }) {
    double fy = height - logoWidth;
    double fx = width - logoWidth;
    double dy = _prop.isFirstGenerated ? fy - _prop.y : _prop.cy ?? fy;
    double dx = _prop.cx ?? calculateOppositeLength(movementAngle, dy);

    _prop.isFirstGenerated = false;

    if (_prop.isRight && (_prop.x + dx > fx)) {
      double ax = fx - _prop.x;
      double bx = dx - ax;
      double ay = calculateAdjecentLength(movementAngle, ax);

      _prop.x = fx;
      _prop.y = _prop.isDown ? ay : fy - ay;
      _prop.isRight = false;
      _prop.cx = bx;
      _prop.cy = dy - ay;

      return Offset(_prop.x, _prop.y);
    } else if (!_prop.isRight && (_prop.x - dx < 0)) {
      double ax = _prop.x;
      double bx = dx - ax;
      double ay = calculateAdjecentLength(movementAngle, ax);

      _prop.x = 0;
      _prop.y = _prop.isDown ? ay : fy - ay;
      _prop.isRight = true;
      _prop.cx = bx;
      _prop.cy = dy - ay;

      return Offset(_prop.x, _prop.y);
    }

    _prop.cx = _prop.cy = null;
    _prop.x += _prop.isRight ? dx : -dx;
    _prop.y = _prop.isDown ? fy : 0;
    _prop.isDown = !_prop.isDown;

    return Offset(_prop.x, _prop.y);
  }
}
