import 'dart:math' as math;

import '_base.dart';
import 'package:flutter/material.dart';

final Image _baseSprite = Image.asset('assets/images/dokutah.png');

class _Properties {
  double rotationZ = 0;
  double rotationY = 0;
  bool isWalking = false;
}

/// The state object of [DokutahSprite].
class DokutahSpriteState extends AnimatedSpriteState {
  final _Properties _prop = _Properties();
  late AnimatedSpriteAnimation<double> _walkAnim;

  bool get isWalking => _prop.isWalking;

  /// Usually it is used as the way to determine the character's facing.
  double get rotationY => _prop.rotationY;

  /// It is used as the way to portray the character's movement
  double get rotationZ => _prop.rotationZ;

  @override
  void initState() {
    super.initState();
  }

  void _animateWalking() async {
    if (!_prop.isWalking) return;
    _walkAnim = animate<double>(
      from: 0,
      to: 3.75,
      duration: const Duration(milliseconds: 150),
      onUpdated: (value) {
        _prop.rotationZ = value;
      },
    );

    await _walkAnim.waitUntilCompleted();
    if (!_prop.isWalking) return;

    _walkAnim = animate<double>(
      from: 3.75,
      to: 0,
      duration: const Duration(milliseconds: 150),
      onUpdated: (value) {
        _prop.rotationZ = value;
      },
    );

    await _walkAnim.waitUntilCompleted();
    if (!_prop.isWalking) return;

    _walkAnim = animate<double>(
      from: 0,
      to: -3.75,
      duration: const Duration(milliseconds: 150),
      onUpdated: (value) {
        _prop.rotationZ = value;
      },
    );

    await _walkAnim.waitUntilCompleted();
    if (!_prop.isWalking) return;

    _walkAnim = animate<double>(
      from: -3.75,
      to: 0,
      duration: const Duration(milliseconds: 150),
      onUpdated: (value) {
        _prop.rotationZ = value;
      },
    );

    await _walkAnim.waitUntilCompleted();
    if (_prop.isWalking) _animateWalking();
  }

  /// Run the dokutah's walking animation.
  void walk() async {
    _prop.isWalking = true;
    _animateWalking();
  }

  /// Change the dokutah's facing
  void rotate([double degree = 180]) {
    animate<double>(
      from: _prop.rotationY,
      to: degree,
      duration: const Duration(milliseconds: 100),
      onUpdated: (value) {
        _prop.rotationY = value;
      },
      onCompleted: () {
        _prop.rotationY %= 360;
      },
    );
  }

  /// Stop the dokutah's walkin aniimation.
  void stopWalking() {
    _prop.isWalking = false;
    _walkAnim.stop();
  }

  @override
  Widget build(BuildContext context) {
    Matrix4 transform = Matrix4.identity()
      ..rotateX(0 / 180 * math.pi)
      ..rotateY(_prop.rotationY / 180 * math.pi)
      ..rotateZ(_prop.rotationZ / 180 * math.pi);
    return Transform(
      alignment: Alignment.bottomCenter,
      transform: transform,
      child: _baseSprite,
    );
  }
}

/// The widget of the dokutah's sprite.
class DokutahSprite extends AnimatedSprite {
  const DokutahSprite({Key? key}) : super(key: key);

  @override
  DokutahSpriteState createState() => DokutahSpriteState();
}
