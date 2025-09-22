import 'package:flutter/material.dart';

class AdditonalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditonalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, 
        size: 34),
        SizedBox(height: 10),
        Text(label,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        ),
        SizedBox(height: 10),
        Text(value,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        ),
       ],
      );
  }
}