import 'dart:async';

import 'package:flutter/material.dart';

/// The widget of any animatable sprite.
abstract class AnimatedSprite extends StatefulWidget {
  const AnimatedSprite({Key? key}) : super(key: key);
}

/// The state of [AnimatedSprite].
abstract class AnimatedSpriteState extends State<AnimatedSprite>
    with TickerProviderStateMixin {
  void _update() {
    setState(() {});
  }

  /// Perform the animation with value.
  ///
  /// This method will return [AnimatedSpriteAnimation].
  AnimatedSpriteAnimation<T> animate<T extends dynamic>({
    required T from,
    required T to,
    required Duration duration,
    void Function()? onCompleted,
    void Function(T value)? onUpdated,
  }) {
    AnimatedSpriteAnimation<T> a = AnimatedSpriteAnimation<T>(this);

    a._diffValue = to - from;
    a._startValue = from;
    a._controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    a._animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(a._controller);
    a.onCompleted = onCompleted;
    a.onUpdated = onUpdated;

    a._start();
    return a;
  }
}

/// The object for controlling the animation with simply methods
class AnimatedSpriteAnimation<T extends dynamic> {
  void Function()? onCompleted;
  void Function(T value)? onUpdated;
  dynamic _diffValue;
  dynamic _startValue;
  late Animation<double> _animation;
  late AnimationController _controller;
  final AnimatedSpriteState _widget;
  late Completer<void> _completer;

  AnimatedSpriteAnimation(this._widget);

  T get value => _startValue + (_diffValue * _animation.value);

  /// Return the [Future] object that it will be completed after animation is finished or stopped.
  Future<void> waitUntilCompleted() => _completer.future;

  void _start() {
    _completer = Completer<void>();

    _controller
      ..addListener(() {
        onUpdated?.call(value);
        _widget._update();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _completer.complete();
          onCompleted?.call();
        }
      })
      ..forward();
  }

  /// Stop the animation
  void stop() {
    if (_controller.isAnimating) _controller.reset();
    if (!_completer.isCompleted) _completer.complete();
  }
}
