import 'package:flutter/material.dart';

import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400.withOpacity(0.9),
        elevation: 5,
        shadowColor: Colors.transparent.withOpacity(0.5),
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Text("Tema Escuro"),
            const SizedBox(width: 10),
            Switch(
              onChanged: (value) {
                controller.updateThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
              value: controller.themeMode == ThemeMode.dark,
            ),
          ],
        ),
      ),
    );
  }
}
