import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PredictionDetailScreen extends StatelessWidget {
  final String imageBase64;
  final String disease;
  final String prescription;
  final String accuracy;
  final String geminiResponse;
  final DateTime timestamp;

  const PredictionDetailScreen({
    Key? key,
    required this.imageBase64,
    required this.disease,
    required this.prescription,
    required this.accuracy,
    required this.geminiResponse,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Details',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w600,
            ).copyWith(fontSize: 27)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${timestamp.toLocal()}'),
              SizedBox(
                height: 10,
              ),
              Text(
                'Disease: $disease',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text('Prescription: $prescription'),
              Text('Accuracy: $accuracy%'),
              SizedBox(height: 10),
              Text('Gemini Response:'),
              Text(geminiResponse),
              SizedBox(height: 10),
              Image.memory(
                base64Decode(imageBase64),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
