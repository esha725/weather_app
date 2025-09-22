import 'package:flutter/material.dart';

class HourlyForcastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForcastItem({super.key,
  required this.time,
  required this.icon,
  required this.temp,
  });
  

  @override
  Widget build(BuildContext context) {
    return       Card(
                  elevation: 6,
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                         children: [
                           Text(time,
                            style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                           ),
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                           ),
                           const SizedBox(height: 8),
                           Icon(icon, size: 50),
                           const SizedBox(height: 8),
                           Text(temp, style: TextStyle(
                            fontSize: 14,
                           ),
                           ),
                         ],
                      ),
                    ),
                  ),
                );
  }
}
