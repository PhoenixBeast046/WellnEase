//lib\services\mood_service.dart
import 'package:flutter/material.dart';

enum Mood { happy, sad, angry, calm, stressed }

class MoodService extends ChangeNotifier {
  Mood? _current;

  Mood? get current => _current;

  void setMood(Mood m) {
    _current = m;
    notifyListeners();
  }

  String get label => _current?.name ?? 'Unknown';

  /// Returns one of the 3 motivational messages supplied in the brief
  String get suggestion {
    if (_current == null) return '';
    switch (_current!) {
      case Mood.happy:
        return 'Glad to see you happy! Keep enjoying the moment!';
      case Mood.sad:
        return 'It\'s okay to feel sad. Take a deep breath and be kind to yourself.';
      case Mood.angry:
        return 'Anger is natural. Take a deep breath and count to 10.';
      case Mood.calm:
        return 'Staying calm is powerful. Enjoy the peace!';
      case Mood.stressed:
        return 'Your mind is working overtime—give it a break!';
    }
  }
}
