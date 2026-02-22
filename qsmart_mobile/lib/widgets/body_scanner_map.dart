// lib/widgets/body_scanner_map.dart

import 'package:flutter/material.dart';
import '../models/tension_display_point.dart';
import 'tension_dot.dart';
import '../theme/qsmart_theme.dart';

class BodyScannerMap extends StatelessWidget {
  final List<TensionDisplayPoint> tensionData;
  final BodySide side;
  final String imageAsset;

  const BodyScannerMap({
    super.key,
    required this.tensionData,
    required this.side,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    final sidePoints = tensionData.where((p) => p.side == side).toList();

    return Container(
      // One consistent background for both front + back
      color: AppColors.deepNavy,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final bodyImage = Image.asset(
            imageAsset,
            fit: BoxFit.contain,
          );

          final dotWidgets = sidePoints.map((point) {
            final xPos = point.xRatio * width;
            final yPos = point.yRatio * height;
            final dotRadius = 10.0 + (point.severity * 15.0);

            return Positioned(
              left: xPos,
              top: yPos,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Region: ${point.region} (Tension: ${(point.severity * 100).toStringAsFixed(0)}%)',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Tooltip(
                  message: point.region,
                  child: Transform.translate(
                    offset: Offset(-dotRadius, -dotRadius),
                    child: TensionDot(severity: point.severity),
                  ),
                ),
              ),
            );
          }).toList();

          return Stack(
            alignment: Alignment.center,
            children: [
              // Just the body with its built-in halo
              Positioned.fill(
                child: bodyImage,
              ),
              ...dotWidgets,
            ],
          );
        },
      ),
    );
  }
}
