//lib\screens\health\sleep_quality_entry_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/data_service.dart';

class SleepQualityEntryPage extends StatefulWidget {
  const SleepQualityEntryPage({super.key});
  @override
  State<SleepQualityEntryPage> createState() => _SleepQualityEntryPageState();
}

class _SleepQualityEntryPageState extends State<SleepQualityEntryPage> {
  final _formKey = GlobalKey<FormState>();
  int? _score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Sleep Quality'),
        backgroundColor: const Color(0xFF7B9E9B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Sleep Score (0–100)'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                return n == null || n < 0 || n > 100 ? '0–100' : null;
              },
              onSaved: (v) => _score = int.parse(v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  context
                      .read<DataService>()
                      .addSample(sleepScore: _score);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            )
          ]),
        ),
      ),
    );
  }
}
