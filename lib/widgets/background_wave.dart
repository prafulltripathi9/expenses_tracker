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

    path.lineTo(0, size.height * 0.65);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.45,
      size.width * 0.50,
      size.height * 0.65,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.85,
      size.width,
      size.height * 0.60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  shouldReclip(covariant CustomClipper<Path> oldClipper){
    return false;

  }
}
