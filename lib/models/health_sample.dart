class HealthSample {
  final DateTime when;
  final int heartRate;      // bpm
  final int sleepScore;     // 0‑5 subjective

  HealthSample({
    required this.when,
    required this.heartRate,
    required this.sleepScore,
  });
}
