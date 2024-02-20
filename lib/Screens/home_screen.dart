import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healwiz/themes/theme.dart';
import 'package:lottie/lottie.dart';
import 'package:neumorphic_button/neumorphic_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _healthData = ''; // Variable to hold health data from API
  bool _isLoading = false;
  String _error = '';
  bool _geminiProcessing = false; // Variable to track Gemini processing state
  String _userName = ''; // Variable to hold user's first name
  Map<String, dynamic> _responseData =
      {}; // Define responseData at the class level
  String _geminiResponse = ''; // Variable to hold Gemini's response

  @override
  void initState() {
    super.initState();
    _loadUserData();
    Gemini.init(apiKey: 'AIzaSyA7cRxIVJbSSzw_etGyUWEUNnVtY1F7wOk');
  }

  Future<void> _loadUserData() async {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Get the user document from Firestore
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .get();

        // Check if the widget is still mounted before updating the state
        if (mounted) {
          // Get the user's name field from the document
          setState(() {
            _userName = snapshot['name'];
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          _userName.isNotEmpty ? 'Hello, $_userName!' : 'Hello!',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.w600,
          ).copyWith(fontSize: 27),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFF7870C6),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.white.withOpacity(0.3), // Shadow color
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: MaterialButton(
                          color: AppColor.bgColor1,
                          child: const Text(
                            "Upload File",
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                              _error = '';
                            });
                            await pickfiles();
                            setState(() {
                              _isLoading = false;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _isLoading
                            ? 'Loading...'
                            : (_error.isNotEmpty
                                ? 'Error: $_error'
                                : 'Please upload an image'),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SingleChildScrollView(
                  child: NeumorphicButton(
                    borderRadius: 12,
                    bottomRightShadowBlurRadius: 15,
                    bottomRightShadowSpreadRadius: 10,
                    borderWidth: 3,
                    backgroundColor: Colors.white,
                    topLeftShadowBlurRadius: 15,
                    topLeftShadowSpreadRadius: 1,
                    topLeftShadowColor: Colors.white,
                    bottomRightShadowColor: Colors.grey.shade500,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(50),
                    bottomRightOffset: const Offset(4, 4),
                    topLeftOffset: const Offset(-4, -4),
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: SingleChildScrollView(
                        // padding: EdgeInsets.all(25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Your results will appear here:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  CircularPercentIndicator(
                                    animation: true,
                                    animationDuration: 2000,
                                    radius: 80.0,
                                    lineWidth: 12.0,
                                    percent: _healthData.isNotEmpty
                                        ? double.tryParse(
                                                _responseData['accuracy'] ??
                                                    '0.0')! /
                                            100.0
                                        : 0.0,
                                    center: Text(
                                      _healthData.isNotEmpty
                                          ? "${double.tryParse(_responseData['accuracy'] ?? '0.0')}%"
                                          : "0.0%",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    progressColor: AppColor.bgColor1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Stack(
                              children: [
                                Visibility(
                                  visible: _isLoading,
                                  child: Lottie.asset(
                                    "assets/animation2.json",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Visibility(
                                  visible: !_isLoading,
                                  child: Text(
                                    _healthData.isNotEmpty
                                        ? _healthData
                                        : 'We are this accurate with our response',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SingleChildScrollView(
                  child: NeumorphicButton(
                    borderRadius: 12,
                    bottomRightShadowBlurRadius: 15,
                    bottomRightShadowSpreadRadius: 10,
                    borderWidth: 3,
                    backgroundColor: Colors.white,
                    topLeftShadowBlurRadius: 15,
                    topLeftShadowSpreadRadius: 1,
                    topLeftShadowColor: Colors.white,
                    bottomRightShadowColor: Colors.grey.shade500,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(50),
                    bottomRightOffset: const Offset(4, 4),
                    topLeftOffset: const Offset(-4, -4),
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: SingleChildScrollView(
                        // padding: EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Let\'s see what Gemini says:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Loading indicator for Gemini processing
                            if (_geminiProcessing)
                              Lottie.asset("assets/animation.json"),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              _geminiProcessing
                                  ? 'Gemini will respond shortly...'
                                  : (_geminiResponse.isNotEmpty
                                      ? _geminiResponse
                                      : 'Waiting for disease identification...'),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickfiles() async {
    // Reset older data and Gemini response
    setState(() {
      _healthData = '';
      _geminiResponse = '';
      _error = '';
    });
    // Step 1: Select the media file
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.media);

    if (result != null) {
      File file = File(result.files.single.path ?? "");

      try {
        // Read the file as bytes
        List<int> imageBytes = await file.readAsBytes();

        // Encode the image bytes to base64
        String base64Image = base64Encode(imageBytes);
        print('Base64 URL: $base64Image');
        // Step 3: Share base64 encoded image to API
        await _shareDataToAPI(base64Image);
      } catch (e) {
        print('Error encoding image to base64: $e');
        setState(() {
          _error = 'Error encoding image to base64';
        });
      }
    }
  }

  Future<void> _shareDataToAPI(String base64Image) async {
    try {
      // Step 4: Share base64 encoded image to API
      Dio dio = Dio();
      dio.options.connectTimeout = Duration(seconds: 5000); // milliseconds
      dio.options.receiveTimeout = Duration(minutes: 5); // milliseconds

      var body = {'url': base64Image}; // Data to send in the body

      Response response = await dio.post(
        'https://healwiz-backend.onrender.com/predict_skin',
        data: body, // Specify the data object
      );

      if (response.statusCode == 200) {
        print('Image data shared to API successfully');
        print('API Response: ${response.data}');

        // Parse the JSON response and extract required parameters
        _responseData = response.data; // Update the responseData
        String disease = _responseData['disease'] ?? 'N/A';
        String prescription = _responseData['medicine'] ?? 'N/A';
        String accuracy = _responseData['accuracy'] ?? 'N/A';

        setState(() {
          _healthData =
              'Disease: $disease\nPrescription: $prescription\nAccuracy: $accuracy';
        });

        // Send disease information to Gemini for reply
        if (disease != 'N/A') {
          await _sendToGemini(disease);
        }
      } else {
        print('Failed to share image data to API');
        setState(() {
          _error = 'Failed to share image data to API';
        });
      }
    } catch (e) {
      print('Error sharing data to API: $e');
      setState(() {
        _error = 'Error sharing data to API';
      });
    }
  }

  Future<void> _sendToGemini(String disease) async {
    try {
      // Set Gemini processing state to true when sending data
      setState(() {
        _geminiProcessing = true;
      });

      final gemini = Gemini.instance;

      gemini.text("$disease").then((value) {
        // Print the response to the console
        print(value?.output);

        setState(() {
          _geminiResponse = value?.output ?? 'No response from Gemini';
          _geminiProcessing =
              false; // Set processing state to false after response
        });
      }).catchError((e) {
        // Handle errors
        print(e);
        setState(() {
          _geminiProcessing = false; // Set processing state to false on error
        });
      });
    } catch (e) {
      print('Error sending data to Gemini: $e');
      setState(() {
        _geminiProcessing = false; // Set processing state to false on error
      });
    }
  }
}
