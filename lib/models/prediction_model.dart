class PredictionModel {
  int? id;
  String imageBase64;
  String disease;
  String prescription;
  double accuracy;
  String geminiResponse;
  DateTime timestamp;

  PredictionModel({
    this.id,
    required this.imageBase64,
    required this.disease,
    required this.prescription,
    required this.accuracy,
    required this.geminiResponse,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageBase64': imageBase64,
      'disease': disease,
      'prescription': prescription,
      'accuracy': accuracy,
      'geminiResponse': geminiResponse,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
