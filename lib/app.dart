import 'package:flutter/widgets.dart';

import 'models/bouncing_logo.dart';
import 'units/dokutah.dart';

/// The entire app.
class App extends StatelessWidget {
  final String appName = 'The Bouncing Dokutah';

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<DokutahState> key = GlobalKey();

    const double dokutahWidth = 128;
    const double movementAngle = 45;
    Dokutah dokutah = Dokutah(
      x: 0,
      y: 0,
      collisionRadius: dokutahWidth / 2,
      key: key,
    );
    BouncingLogoModel coordinator = BouncingLogoModel(
      movementAngle: movementAngle,
      logoWidth: dokutahWidth,
      startX: 0,
      startY: 0,
    );

    void dokutahMove() async {
      Offset gen = coordinator.generate(
        width: context.size?.width ?? 0,
        height: context.size?.height ?? 0,
      );

      await key.currentState?.moveTo(x: gen.dx, y: gen.dy).waitUntilCompleted();
      key.currentState?.rotate(coordinator.isRight);
      dokutahMove();
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      dokutahMove();
    });

    return Title(
      title: appName,
      color: const Color(0xFFFFFFFF),
      child: Container(
        color: const Color(0xFF000000),
        alignment: Alignment.topLeft,
        child: dokutah,
      ),
    );
  }
}
