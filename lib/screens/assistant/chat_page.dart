import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:provider/provider.dart';

import '../../services/data_service.dart';
import '../../services/openai_service.dart';
import '../profile_page.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/assistant';
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin {
  final _input = TextEditingController();
  final _openAi = OpenAiService();
  final List<_Msg> _log = [];
  bool _waiting = false;
  late final String _mood;

  String buildSmartPrompt(int hr, int sleep, String mood) {
  String alert = '';
  if (hr > 100) {
    alert += '⚠️ The user’s heart rate is high at $hr bpm. This could indicate stress, anxiety, or exertion.\n';
  } else if (hr < 60) {
    alert += '💡 The heart rate is quite low at $hr bpm. If they feel dizzy, suggest hydration or gentle movement.\n';
  } else {
    alert += '🫀 The heart rate of $hr bpm is within a normal range.\n';
  }

  if (sleep < 5) {
    alert += '😴 The user has had very little sleep ($sleep hours), which can impact mood, memory, and physical health.\n';
  } else if (sleep >= 8) {
    alert += '✅ The user slept $sleep hours — excellent for recovery and focus.\n';
  } else {
    alert += '💤 The sleep duration is $sleep hours, which is okay but could be improved.\n';
  }

  return '''
The user’s vitals:
- Heart Rate: $hr bpm
- Sleep: $sleep hours
- Mood: $mood

$alert

Instructions:
1. Greet the user and summarize their heart rate, sleep, and mood in your first line.
2. Offer at least one concrete wellness suggestion (e.g. "Take 3 deep breaths", "Try a short stretch", "Drink a glass of water").
3. Close with an uplifting or calming thought (e.g. "You're doing your best today, and that matters 💛").

Tone:
- Friendly and supportive
- 2–3 sentences only
- No technical terms or diagnosis
- Speak like a trusted wellness companion
''';
}

  @override
  bool get wantKeepAlive => true;

  String get _effectiveMood => _mood.isEmpty ? 'neutral' : _mood;

  String get _systemPrompt {
    const suffix = '\nPlease respond in a single short paragraph of 2-3 lines.';
    switch (_effectiveMood) {
      case 'happy':
        return '''
You are a cheerful wellness companion. The user is feeling happy.
Begin by greeting them warmly and asking how they'd like to celebrate this moment.$suffix''';
      case 'sad':
        return '''
You are a gentle, empathetic therapist. The user is feeling sad.
Begin by validating their feelings and inviting them to share more to help lift their spirits.$suffix''';
      case 'angry':
        return '''
You are a calm, soothing coach. The user is feeling angry.
Begin by acknowledging their frustration, guiding them through a breathing exercise, and asking what's on their mind.$suffix''';
      case 'calm':
        return '''
You are a mindfulness guide. The user is feeling calm.
Begin by acknowledging their peaceful state and offering a short mindfulness tip.$suffix''';
      case 'stressed':
        return '''
You are a stress-relief coach. The user is feeling stressed.
Begin by guiding them through a quick breathing exercise and asking which task is weighing on them.$suffix''';
      default:
        return '''
You are a compassionate wellness assistant. The user hasn't specified a mood.
Begin by greeting them and asking, “How can I support you today?”$suffix''';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments;
    _mood = (arg is String) ? arg : '';
    if (_log.isEmpty) {
      _startConversation();
    }
  }

  Future<void> _startConversation() async {
    setState(() => _waiting = true);

    // pull latest vitals & mood from DataService
    final data = context.read<DataService>();
    final recent = data.getLastSamples(1);
    final hr = recent.isNotEmpty ? recent.first.heartRate : 0;
    final sleep = recent.isNotEmpty ? recent.first.sleepScore : 0;
    final mood = data.lastMood ?? 'neutral';

    // first seed with vitals, then systemPrompt
    final messages = [
     OpenAIChatCompletionChoiceMessageModel(
  role: OpenAIChatMessageRole.system,
  content: [
    OpenAIChatCompletionChoiceMessageContentItemModel.text(
      buildSmartPrompt(hr, sleep, mood)
    )
  ],
), 
    ];

    final resp = await _openAi.chat(messages: messages);
    final reply = resp.choices.first.message.content
            ?.map((c) => c.text)
            .whereType<String>()
            .join()
            .trim() ??
        '';

    setState(() {
      _waiting = false;
      _log.add(_Msg(who: 'assistant', text: reply));
    });
  }

  Future<void> _send() async {
    final txt = _input.text.trim();
    if (txt.isEmpty || _waiting) return;

    setState(() {
      _log.add(_Msg(who: 'user', text: txt));
      _waiting = true;
      _input.clear();
    });

    // pull vitals again
    final data = context.read<DataService>();
    final recent = data.getLastSamples(1);
    final hr = recent.isNotEmpty ? recent.first.heartRate : 0;
    final sleep = recent.isNotEmpty ? recent.first.sleepScore : 0;
    final mood = data.lastMood ?? 'neutral';

    // rebuild full history
    final history = <OpenAIChatCompletionChoiceMessageModel>[
      OpenAIChatCompletionChoiceMessageModel(
  role: OpenAIChatMessageRole.system,
  content: [
    OpenAIChatCompletionChoiceMessageContentItemModel.text(
      buildSmartPrompt(hr, sleep, mood)
    )
  ],
),
      ..._log.map((m) {
        final role = m.who == 'user'
            ? OpenAIChatMessageRole.user
            : OpenAIChatMessageRole.assistant;
        return OpenAIChatCompletionChoiceMessageModel(
          role: role,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(m.text)
          ],
        );
      }),
    ];

    final resp = await _openAi.chat(messages: history);
    final reply = resp.choices.first.message.content
            ?.map((c) => c.text)
            .whereType<String>()
            .join()
            .trim() ??
        '';

    setState(() {
      _waiting = false;
      _log.add(_Msg(who: 'assistant', text: reply));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // for AutomaticKeepAliveClientMixin
    final avatarPath = context.watch<DataService>().avatarPath;
    final avatarImage = avatarPath != null
        ? FileImage(File(avatarPath))
        : const AssetImage('assets/placeholder_logo.png')
            as ImageProvider;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assistant (${_effectiveMood[0].toUpperCase()}${_effectiveMood.substring(1)})',
        ),
        backgroundColor: const Color(0xFF7B9E9B),
        actions: [
          IconButton(
            icon: CircleAvatar(backgroundImage: avatarImage),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _log.length,
              itemBuilder: (_, i) {
                final m = _log[i];
                final isUser = m.who == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(m.text),
                  ),
                );
              },
            ),
          ),
          if (_waiting)
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Assistant is typing...',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ),
  ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      decoration: const InputDecoration(
                        hintText: 'Type your message…',
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                        _waiting ? Icons.hourglass_empty : Icons.send),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  final String who; // 'user' or 'assistant'
  final String text;
  _Msg({required this.who, required this.text});
}
