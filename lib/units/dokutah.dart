import 'package:flutter/material.dart';
import '../sprites/dokutah.dart';
import '_base.dart';

/// The state object of [Dokutah]
class DokutahState extends UnitState<Dokutah> {
  final GlobalKey<DokutahSpriteState> _spriteKey = GlobalKey();
  @override
  Widget createSprite(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: DokutahSprite(
        key: _spriteKey,
      ),
    );
  }

  @override
  void didStartMoving() {
    _spriteKey.currentState?.walk();
  }

  @override
  void didStopMoving() {
    _spriteKey.currentState?.stopWalking();
  }

  /// Rotate the dokutah.
  void rotate(bool isRight) {
    if (_spriteKey.currentState?.rotationY != 0 && isRight) {
      _spriteKey.currentState?.rotate(360);
    } else if (_spriteKey.currentState?.rotationY != 180 && !isRight) {
      _spriteKey.currentState?.rotate(180);
    }
  }
}

/// The dokutah's unit.
class Dokutah extends Unit {
  Dokutah({
    Key? key,
    required double x,
    required double y,
    required double collisionRadius,
  }) : super(
          key: key,
          x: x,
          y: y,
          collisionRadius: collisionRadius,
        );

  @override
  DokutahState createState() => DokutahState();
}
