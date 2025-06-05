import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/data_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final avatarPath = context.watch<DataService>().avatarPath;
    final imageProvider = avatarPath != null
        ? FileImage(File(avatarPath))
        : const AssetImage('assets/placeholder_logo.png')
            as ImageProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: const Color(0xFF7B9E9B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: imageProvider,
            ),
          ),
          const SizedBox(height: 24),
          const ListTile(title: Text('Name'), subtitle: Text('Guest')),
          const Divider(),
          const ListTile(title: Text('Age'), subtitle: Text('--')),
          const Divider(),
          const ListTile(title: Text('Weight'), subtitle: Text('-- kg')),
          const Divider(),
          const ListTile(title: Text('Height'), subtitle: Text('-- cm')),
        ],
      ),
    );
  }
}
