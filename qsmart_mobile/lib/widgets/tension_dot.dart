// lib/widgets/tension_dot.dart

import 'package:flutter/material.dart';

class TensionDot extends StatelessWidget {
  final double severity; 

  const TensionDot({super.key, required this.severity});
  
  double get _dotRadius => 10.0 + (severity * 15.0); 

  @override
  Widget build(BuildContext context) {
    final double dotOpacity = 0.5 + (severity * 0.5); 

    return Container(
      width: _dotRadius * 2,
      height: _dotRadius * 2, 
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(dotOpacity * 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.4 * severity), 
            blurRadius: _dotRadius / 2,
          ),
          BoxShadow(
            color: Colors.red.withOpacity(0.1), 
            blurRadius: 1.0,
            spreadRadius: -2.0, 
          ),
        ],
      ),
    );
  }
}