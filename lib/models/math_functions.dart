import 'dart:math';

double calculateDirectPathLength(
  double ax,
  double ay,
  double bx,
  double by,
) =>
    (sqrt(pow(bx - ax, 2) + pow(by - ay, 2))).toDouble();

double calculateOppositeLength(double angle, double adjecent) =>
    tan((angle / 180) * pi) * adjecent;

double calculateAdjecentLength(double angle, double opposite) =>
    opposite / tan((angle / 180) * pi);
