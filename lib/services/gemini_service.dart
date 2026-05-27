import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static GenerativeModel? _model;

  static GenerativeModel? get model => _model;

  static void initialize() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isNotEmpty) {
      _model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );
    }
  }

  static bool get isAvailable => _model != null;
}
