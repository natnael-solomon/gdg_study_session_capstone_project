import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          TextButton(
            onPressed:() => {Center(child: Text("hhhh"),)},
            child: Text(
              "See All",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
