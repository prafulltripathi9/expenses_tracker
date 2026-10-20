import 'package:flutter/material.dart';

class BackgroundWave extends StatelessWidget {
  final Color color;

  const BackgroundWave({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(color: color),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, size.height * 0.30);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.30,
      size.width * 0.48,
      size.height * 0.70,
    );

    path.quadraticBezierTo(
      size.width * 0.70,
      size.height * 0.95,
      size.width,
      size.height * 0.45,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
