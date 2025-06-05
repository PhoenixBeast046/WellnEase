// lib/services/openai_service.dart

import 'package:dart_openai/dart_openai.dart';
import '../env/env.dart';

class OpenAiService {
  OpenAiService() {
    OpenAI.apiKey = Env.apiKey;
  }

  /// Default to the lightweight GPT‑4o‑mini model.
  Future<OpenAIChatCompletionModel> chat({
    required List<OpenAIChatCompletionChoiceMessageModel> messages,
    String model = 'gpt-4o-mini',
  }) {
    return OpenAI.instance.chat.create(
      model: model,
      messages: messages,
    );
  }
}
