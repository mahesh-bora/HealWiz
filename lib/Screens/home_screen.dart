import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../themes/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _healthData = ''; // Variable to hold health data from API
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 55,
              ),
              Text("Hello, Mahesh!",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ).copyWith(color: AppColor.kGrayscaleDark100, fontSize: 30)),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: MaterialButton(
                              color: Colors.blueAccent,
                              child: const Text(
                                "Upload File",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                pickfiles();
                                // var source = ImageSource.gallery;
                                // XFile? image =
                                //     await _picker.pickVideo(source: source);
                                // if (image != null) {
                                //   setState(() {
                                //     _hasUploadStarted = true;
                                //   });
                                //   try {
                                //     var video = await ApiVideoUploader
                                //         .uploadWithUploadToken(
                                //             _tokenTextController.text,
                                //             image.path, onProgress: (progress) {
                                //       log("Progress :$progress");
                                //       setProgress(progress);
                                //     });
                                //     log("VideoId : ${video.videoId}");
                                //     log("Title : ${video.title}");
                                //     showSuccessSnackBar(context,
                                //         "Video ${video.videoId} uploaded");
                                //   } on Exception catch (e) {
                                //     log("Failed to upload video: $e");
                                //     showErrorSnackBar(context,
                                //         "Failed to upload video: ${e}");
                                //   } catch (e) {
                                //     log("Failed to upload video: $e");
                                //     showErrorSnackBar(
                                //         context, "Failed to upload video $e");
                                //   }
                                // }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Please upload an image or video",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Your results will appear here: ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ).copyWith(color: AppColor.kGrayscaleDark100, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 275,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    child: Text(
                      'Heart Rate : 80 bpm\n\nBlood Pressure : 120/80 mmHg\n\nBlood Oxygen : 98%\n\nTemperature : 36.5°C\n\nRespiratory Rate : 16 bpm\n\nGlucose : 4.5 mmol/L\n\nCholesterol : 5.5 mmol/L\n\nBMI : 22.5 kg/m²\n\n',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

// void pickfiles() async {
//   // Step 1: Select the image
//   FilePickerResult? result =
//       await FilePicker.platform.pickFiles(type: FileType.media);
//
//   if (result != null) {
//     File file = File(result.files.single.path ?? "");
//
//     // Step 2: Upload image to Firebase Storage
//     String filename = file.path.split('/').last;
//     Reference firebaseStorageRef =
//         FirebaseStorage.instance.ref().child('images/$filename');
//
//     print('Uploading image to Firebase Storage... $firebaseStorageRef');
//
//     UploadTask uploadTask = firebaseStorageRef.putFile(file);
//     print('Uploading image to Firebase Storage... $uploadTask');
//     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
//     print('Uploading image to Firebase Storage... $taskSnapshot');
//     String imageUrl = await taskSnapshot.ref.getDownloadURL();
//     print('Image URL: $imageUrl');
//
//     // Step 3: Send image URL to API
//     try {
//       var dio = Dio();
//       var response = await dio.post(
//         "https://healwiz-backend.onrender.com/predict_skin",
//         data: {'image_url': imageUrl},
//       );
//       print('API Response: ${response.data}');
//     } catch (e) {
//       print('Error sending image URL to API: $e');
//     }
//   } else {
//     print('No image selected.');
//   }
// }
// void pickfiles() async {
//   // Step 1: Select the media file
//   FilePickerResult? result =
//       await FilePicker.platform.pickFiles(type: FileType.media);
//
//   if (result != null) {
//     File file = File(result.files.single.path ?? "");
//
//     try {
//       // Step 2: Upload image to Firebase Storage
//       FirebaseStorage storage = FirebaseStorage.instance;
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       Reference reference = storage.ref().child('images/$fileName');
//       UploadTask uploadTask = reference.putFile(file);
//       // print('Uploading image to Firebase Storage... $taskSnapshot');
//       await uploadTask.whenComplete(() => null);
//       String imageUrl = await reference.getDownloadURL();
//       print('Image URL: $imageUrl');
//
//       // Step 3: Share image URL to API
//       await _shareDataToAPI(imageUrl);
//     } catch (e) {
//       print('Error uploading image to Firebase: $e');
//     }
//   }
// }
//
// Future<void> _shareDataToAPI(String imageUrl) async {
//   try {
//     // Read the image file as bytes
//     File file = File(imageUrl);
//     List<int> imageBytes = await file.readAsBytes();
//
//     // Encode the image bytes to base64
//     String base64Image = base64Encode(imageBytes);
//
//     // Step 4: Share base64 encoded image to API
//     Dio dio = Dio();
//     Response response = await dio.get(
//       'https://healwiz-backend.onrender.com/predict_skin?url=$base64Image',
//       queryParameters: {'image_base64': base64Image},
//     );
//
//     if (response.statusCode == 200) {
//       print('Image data shared to API successfully');
//       print('API Response: ${response.data}');
//     } else {
//       print('Failed to share image data to API');
//     }
//   } catch (e) {
//     print('Error sharing data to API: $e');
//   }
// }

void pickfiles() async {
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
    }
  }
}

Future<void> _shareDataToAPI(String base64Image) async {
  try {
    // Step 4: Share base64 encoded image to API
    Dio dio = Dio();
    dio.options.connectTimeout = Duration(seconds: 5000); // milliseconds
    dio.options.receiveTimeout = Duration(minutes: 5); // milliseconds
    Response response = await dio.get(
      'http://10.0.0.2:5000/predict_skin',
      queryParameters: {'url': base64Image},
    );

    if (response.statusCode == 200) {
      print('Image data shared to API successfully');
      print('API Response: ${response.data}');
    } else {
      print('Failed to share image data to API');
    }
  } catch (e) {
    print('Error sharing data to API: $e');
  }
}
