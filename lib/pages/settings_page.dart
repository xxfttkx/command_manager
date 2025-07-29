import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:command_manager/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:command_manager/viewmodels/settings_viewmodel.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _shellPathController;
  late final TextEditingController _argsTemplateController;

  @override
  void initState() {
    super.initState();
    _shellPathController = TextEditingController();
    _argsTemplateController = TextEditingController();
    _loadShellSettings();
  }

  @override
  void dispose() {
    _shellPathController.dispose();
    _argsTemplateController.dispose();
    super.dispose();
  }

  Future<void> _loadShellSettings() async {
    final settingsViewModel = context.read<SettingsViewModel>();
    _shellPathController.text = settingsViewModel.shellPath;
    _argsTemplateController.text = settingsViewModel.argsTemplate;
    setState(() {}); // 触发 UI 更新
  }

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.tabSettings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsCard(
            title: AppLocalizations.of(context)!.themeColor,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                SettingsViewModel.presetColors.length,
                (i) {
                  final color = SettingsViewModel.presetColors[i];
                  final isSelected = color == settingsViewModel.color;

                  return GestureDetector(
                    onTap: () => settingsViewModel.setColorIndex(i),
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
            title: AppLocalizations.of(context)!.language,
            child: DropdownButton<Locale>(
              value: settingsViewModel.locale,
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  settingsViewModel.setLocale(newLocale);
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
              dropdownColor: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              underline: Container(height: 0), // 去掉下划线
            ),
          ),
          const SizedBox(height: 16),
          _SettingsCard(
            title: AppLocalizations.of(context)!.shellPathTitle,
            child: TextField(
              controller: _shellPathController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!.shellPathHint,
              ),
              onChanged: (_) =>
                  settingsViewModel.setShellPath(_shellPathController.text),
            ),
          ),
          const SizedBox(height: 16),
          _SettingsCard(
            title: AppLocalizations.of(context)!.argsTemplateTitle,
            child: TextField(
              controller: _argsTemplateController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!.argsTemplateHint,
              ),
              onChanged: (_) => settingsViewModel
                  .setArgsTemplate(_argsTemplateController.text),
            ),
          ),
          const SizedBox(height: 16),
          _SettingsCard(
            title: AppLocalizations.of(context)!.advancedSettings,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.newCommandOnTop),
                  value: settingsViewModel.newCommandOnTop,
                  onChanged: (val) => settingsViewModel.setNewCommandOnTop(val),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.runCommandOnTop),
                  value: settingsViewModel.runCommandOnTop,
                  onChanged: (val) => settingsViewModel.setRunCommandOnTop(val),
                  contentPadding: EdgeInsets.zero,
                ),
                fontSizeFactorSlider(
                  context: context,
                  fontSizeFactor: settingsViewModel.fontSizeFactor,
                  onChanged: (val) => settingsViewModel.setFontSizeFactor(val),
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.isAdmin),
                  value: settingsViewModel.isAdmin,
                  onChanged: (val) => {
                    AppSnackbar.showTip(
                      context,
                      AppLocalizations.of(context)!.adminSwitchNotSupported,
                    )
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ],
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

Widget fontSizeFactorSlider({
  required BuildContext context,
  required double fontSizeFactor,
  required ValueChanged<double> onChanged,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(AppLocalizations.of(context)!.fontSizeFactorLabel),
    subtitle: Slider(
      min: 0.5,
      max: 3.0,
      divisions: 25,
      value: fontSizeFactor,
      label: fontSizeFactor.toStringAsFixed(2),
      onChanged: onChanged,
    ),
    trailing: Text(
      fontSizeFactor.toStringAsFixed(2),
      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
    ),
  );
}
