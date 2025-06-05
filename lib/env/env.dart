// lib/env/env.dart

import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  /// Your OpenAI API key (if you still use OpenAI elsewhere)
  @EnviedField(varName: 'OPEN_AI_API_KEY')
  static const String apiKey = _Env.apiKey;

  // /// Your Hugging Face Inference API token for DialoGPT
  // @EnviedField(varName: 'HUGGINGFACE_API_TOKEN')
  // static const String hfApiToken = _Env.hfApiToken;
}
