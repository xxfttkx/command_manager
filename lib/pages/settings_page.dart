import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:command_manager/viewmodels/locale_viewmodel.dart';
import 'package:command_manager/viewmodels/theme_viewmodel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();
    final localeViewModel = context.watch<LocaleViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsCard(
            title: '主题颜色',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                ThemeViewModel.presetColors.length,
                (i) {
                  final color = ThemeViewModel.presetColors[i];
                  final isSelected = color == themeViewModel.color;

                  return GestureDetector(
                    onTap: () => themeViewModel.setColorIndex(i),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 20)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SettingsCard(
            title: '语言',
            child: DropdownButton<Locale>(
              value: localeViewModel.locale,
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  localeViewModel.setLocale(newLocale);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: Locale('zh'),
                  child: Text('简体中文'),
                ),
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
              ],
              icon: const Icon(Icons.language),
              style: const TextStyle(fontSize: 16, color: Colors.black),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              underline: Container(height: 0), // 去掉下划线
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
