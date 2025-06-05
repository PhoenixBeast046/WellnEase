//lib\screens\health\heart_rate_entry_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/data_service.dart';

class HeartRateEntryPage extends StatefulWidget {
  const HeartRateEntryPage({super.key});
  @override
  State<HeartRateEntryPage> createState() => _HeartRateEntryPageState();
}

class _HeartRateEntryPageState extends State<HeartRateEntryPage> {
  final _formKey = GlobalKey<FormState>();
  int? _hr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Heart Rate'),
        backgroundColor: const Color(0xFF7B9E9B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Heart Rate (bpm)'),
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v == null || int.tryParse(v) == null ? 'Enter a number' : null,
              onSaved: (v) => _hr = int.parse(v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  context
                      .read<DataService>()
                      .addSample(heartRate: _hr);
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
