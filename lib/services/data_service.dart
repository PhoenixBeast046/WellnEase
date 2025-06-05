import 'package:flutter/material.dart';

class HealthSample {
  final DateTime when;
  final int heartRate;
  final int sleepScore;
  HealthSample({
    required this.when,
    required this.heartRate,
    required this.sleepScore,
  });
}

class DataService extends ChangeNotifier {
  final List<HealthSample> _samples = [];
  final List<String> _moodHistory = [];
  String? _lastMood;
  String? _avatarPath;

  /// Adds a new health sample (heartRate & sleepScore at now).
  void addSample({int? heartRate, int? sleepScore}) {
    final now = DateTime.now();
    _samples.add(
      HealthSample(
        when: now,
        heartRate: heartRate ?? 0,
        sleepScore: sleepScore ?? 0,
      ),
    );
    notifyListeners();
  }

  /// Returns all samples taken in the past [days] days.
  List<HealthSample> getRecentSamples(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _samples.where((s) => s.when.isAfter(cutoff)).toList();
  }

  /// Returns the last [count] samples, regardless of date.
  List<HealthSample> getLastSamples(int count) {
    final last = _samples.reversed.take(count).toList();
    return last.reversed.toList();
  }

  /// Records a new mood entry and updates the "lastMood".
  void addMood(String mood) {
    _moodHistory.add(mood);
    _lastMood = mood;
    notifyListeners();
  }

  /// Alias for backward compatibility (if any code used setLastMood).
  void setLastMood(String mood) => addMood(mood);

  /// Returns up to [count] most recent moods, oldest→newest.
  List<String> getRecentMoods(int count) {
    final rec = _moodHistory.reversed.take(count).toList();
    return rec.reversed.toList();
  }

  String? get lastMood => _lastMood;

  /// Avatar methods (unchanged).
  void setAvatar(String path) {
    _avatarPath = path;
    notifyListeners();
  }

  String? get avatarPath => _avatarPath;
}
