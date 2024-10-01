import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healwiz/themes/theme.dart';
import 'package:lottie/lottie.dart';
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
  String _selectedType = 'skin'; // Default to skin

  String apiUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:5000';
  String? geminiAPIKEY = dotenv.env['GEMINI_API_KEY'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    Gemini.init(apiKey: 'AIzaSyBjkBbYP0a4EeH6ZK97AS3dxDt62ZrTCjo');
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
              _buildPredictionTypeSelector(), // Add the prediction type selector
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColor.container,
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
                          // height: MediaQuery.sizeOf(context).height,
                          color: AppColor.kLine,
                          child: const Icon(
                            Icons.cloud_upload,
                            color: Colors.grey, // Change color if needed
                            size: 30.0, // Adjust the size if necessary
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
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 350.0, // Set the specific height here
                  padding: const EdgeInsets.all(
                      16.0), // Add padding inside the container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColor.container,
                  ),
                  child: SingleChildScrollView(
                    // Wrap the content in SingleChildScrollView
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
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  constraints: BoxConstraints(
                      maxHeight:
                          350.0), // Use constraints instead of fixed height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.container,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Let\'s see what Gemini says:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_geminiProcessing)
                                Center(
                                    child:
                                        Lottie.asset("assets/animation.json"))
                              else if (_geminiResponse.isNotEmpty)
                                MarkdownBody(
                                  data: _geminiResponse,
                                  styleSheet: MarkdownStyleSheet(
                                    h1: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                    h2: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                    h3: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    p: TextStyle(fontSize: 16),
                                  ),
                                )
                              else
                                Text(
                                  'Waiting for disease identification...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
      Dio dio = Dio();
      dio.options.connectTimeout = Duration(seconds: 5000);
      dio.options.receiveTimeout = Duration(minutes: 5);

      var body = {'url': base64Image};

      // Use the selected type in the API endpoint
      String apiUrl = 'http://10.0.2.2:5000/predict_$_selectedType';

      // Start loading before making the API call
      setState(() {
        _isLoading = true;
        _error = '';
      });

      Response response = await dio.post(
        apiUrl,
        data: body,
      );

      if (response.statusCode == 200) {
        // API response received
        _responseData = response.data;
        String disease = _responseData['disease'] ?? 'N/A';
        String prescription = _responseData['medicine'] ?? 'N/A';
        String accuracy = _responseData['accuracy'] ?? 'N/A';

        // Stop loading after API call is done
        setState(() {
          _isLoading = false; // Stop API loading
          _healthData =
              'Disease: $disease\nPrescription: $prescription\nAccuracy: $accuracy';
        });

        // Store the prediction to Firestore
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // If disease is detected, trigger Gemini API for further information
          if (disease != 'N/A') {
            String geminiResponse =
                await _sendToGemini(disease); // Wait for Gemini to respond
            await FirebaseFirestore.instance.collection('Predictions').add({
              'userId': user.uid,
              'image': base64Image,
              'disease': disease,
              'prescription': prescription,
              'accuracy': accuracy,
              'geminiResponse': geminiResponse, // Store Gemini response here
              'timestamp': Timestamp.now(),
            });
          }
        }
      } else {
        print('Failed to share image data to API');
        setState(() {
          _isLoading = false;
          _error = 'Failed to share image data to API';
        });
      }
    } catch (e) {
      print('Error sharing data to API: $e');
      setState(() {
        _isLoading = false;
        _error = 'Error sharing data to API';
      });
    }
  }

  // Future<String> _sendToGemini(String disease) async {
  //   try {
  //     // Set Gemini processing state to true when sending data
  //     setState(() {
  //       _geminiProcessing = true;
  //     });
  //
  //     final gemini = Gemini.instance;
  //
  //     // Await the response from Gemini
  //     var response = await gemini.text(
  //         "Write me symptoms and prescription for $disease and is it that required to consult a doctor - in beautiful text markdown format. ");
  //
  //     // Get the output or set a fallback value
  //     String geminiOutput = response?.output ?? 'No response from Gemini';
  //
  //     // Update the UI with the response
  //     setState(() {
  //       _geminiResponse = geminiOutput;
  //       _geminiProcessing =
  //           false; // Set processing state to false after response
  //     });
  //
  //     // Return the response string
  //     return geminiOutput;
  //   } catch (e) {
  //     print('Error sending data to Gemini: $e');
  //
  //     // Ensure that the processing state is reset even if there's an error
  //     setState(() {
  //       _geminiProcessing = false;
  //     });
  //
  //     // Throw an exception or return an error message
  //     return 'Error: $e';
  //   }
  // }
  Future<String> _sendToGemini(String disease) async {
    try {
      setState(() {
        _geminiProcessing = true;
      });

      final gemini = Gemini.instance;

      // Request the response from Gemini API
      var response = await gemini.text('''
Provide information about $disease in the following markdown format:

## $disease

### Symptoms

### Prescription


### Consult a Doctor?
[Your recommendation on whether to consult a doctor]

Please ensure all sections are included and properly formatted.
''');

      String geminiOutput = response?.output ?? 'No response from Gemini';

      setState(() {
        _geminiResponse = geminiOutput;
        _geminiProcessing = false;
      });

      return geminiOutput;
    } catch (e) {
      print('Error sending data to Gemini: $e');

      setState(() {
        _geminiProcessing = false;
      });

      return 'Error: $e';
    }
  }

  Widget _buildPredictionTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedType = 'skin';
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedType == 'skin'
                ? Colors.deepPurple
                : AppColor.container,
          ),
          child: Text(
            'Skin',
            style: TextStyle(
              color: _selectedType == 'eye'
                  ? Colors.black
                  : Colors.white, // Text color based on selection
            ),
          ),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedType = 'eye';
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _selectedType == 'eye' ? Colors.deepPurple : AppColor.container,
          ),
          child: Text(
            'Eye',
            style: TextStyle(
              color: _selectedType == 'eye'
                  ? Colors.white
                  : Colors.black, // Text color based on selection
            ),
          ),
        ),
      ],
    );
  }
}
