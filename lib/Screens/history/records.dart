import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PredictionHistoryScreen extends StatelessWidget {
  const PredictionHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prediction History',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Predictions')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var records = snapshot.data!.docs;

          return ListView.builder(
            itemCount: records.length + 1, // Add 1 for the sign-out button
            itemBuilder: (context, index) {
              if (index == records.length) {
                // Sign-out button after the last prediction
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 25.0,
                      ),
                      textStyle:
                          const TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      // Navigate the user back to the login screen after signing out
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('Sign Out'),
                  ),
                );
              }

              var record = records[index];
              var imageBase64 = record['image'];
              var disease = record['disease'];
              var prescription = record['prescription'];
              var accuracy = record['accuracy'];
              var timestamp = (record['timestamp'] as Timestamp).toDate();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Dismissible(
                  key: Key(record.id),
                  direction:
                      DismissDirection.endToStart, // swipe from right to left
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    // Show a confirmation dialog before deletion
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Prediction"),
                          content: const Text(
                              "Are you sure you want to delete this prediction?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    // Delete the document from Firestore
                    FirebaseFirestore.instance
                        .collection('Predictions')
                        .doc(record.id)
                        .delete();

                    // Show a snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Prediction deleted')),
                    );
                  },
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1E4F3),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.deepPurple, width: 3),
                                image: DecorationImage(
                                  image: MemoryImage(base64Decode(imageBase64)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Disease: $disease',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    back: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1E4F3),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prescription: $prescription',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Accuracy: $accuracy%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Prediction Date: ${timestamp.toLocal()}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
