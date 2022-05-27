import 'dart:async';
import 'package:flutter/material.dart';
import '../models/math_functions.dart';

class UnitProperties {
  double x = 0;
  double y = 0;
  double collisionRadius = 0;
}

/// The state object of [Unit]
abstract class UnitState<T extends Unit> extends State<T>
    with TickerProviderStateMixin {
  /// The overrid-required method that it will use as the desired widget tree.
  Widget createSprite(BuildContext context);

  /// The overrid-required method that it will use when the moving process is stopped.
  void didStopMoving();

  /// The overrid-required method that it will use when the moving process is starting.
  void didStartMoving();

  /// Move the unit to the destination.
  UnitMovingProcess moveTo({
    required double x,
    required double y,
    double velocity = 100,
  }) {
    UnitMovingProcess process = UnitMovingProcess(this, x, y, velocity);
    process._start();
    return process;
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          widget._prop.x,
          widget._prop.y,
        ),
      child: SizedBox.square(
        dimension: widget._prop.collisionRadius * 2,
        child: createSprite(context),
      ),
    );
  }
}

/// The object for controlling the unit's moving.
class UnitMovingProcess {
  void Function()? onCompleted;
  void Function(Offset value)? onUpdated;
  late Animation<Offset> _animation;
  late AnimationController _controller;
  final UnitState state;
  late Completer<void> _completer;

  UnitMovingProcess(this.state, double dx, double dy, double velocity) {
    double diffRange = calculateDirectPathLength(
        state.widget._prop.x, state.widget._prop.y, dx, dy);
    _controller = AnimationController(
      duration: Duration(
        milliseconds: (diffRange / velocity * 1000).abs().toInt(),
      ),
      vsync: state,
    );

    _animation = Tween<Offset>(
      begin: Offset(state.widget._prop.x, state.widget._prop.y),
      end: Offset(dx, dy),
    ).animate(_controller);
  }

  /// Return the [Future] object that it will be completed after the unit reached the destination or stopped.
  Future<void> waitUntilCompleted() => _completer.future;

  void _start() {
    _completer = Completer<void>();

    state.didStartMoving();
    _controller
      ..addListener(() {
        onUpdated?.call(_animation.value);
        state.widget._prop.x = _animation.value.dx;
        state.widget._prop.y = _animation.value.dy;
        state._update();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          state.didStopMoving();
          _completer.complete();
          onCompleted?.call();
        }
      })
      ..forward();
  }

  /// Stop the unit's moving process.
  void stop() {
    state.didStopMoving();
    if (_controller.isAnimating) _controller.stop();
    if (!_completer.isCompleted) _completer.complete();
  }
}

/// The representation of a unit.
abstract class Unit extends StatefulWidget {
  final UnitProperties _prop = UnitProperties();

  Unit({
    Key? key,
    double x = 0,
    double y = 0,
    double collisionRadius = 0,
  }) : super(key: key) {
    _prop.x = x;
    _prop.y = y;
    _prop.collisionRadius = collisionRadius;
  }
}
