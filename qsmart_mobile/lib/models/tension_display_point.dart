enum BodySide { front, back }

class TensionDisplayPoint {
  final String region;
  final double xRatio;
  final double yRatio;
  final double severity;
  final BodySide side;

  TensionDisplayPoint({
    required this.region,
    required this.xRatio,
    required this.yRatio,
    required this.severity,
    this.side = BodySide.front,
  });
}
