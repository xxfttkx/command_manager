import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:command_manager/pages/finished_commands_page.dart';
import 'package:command_manager/pages/running_commands_page.dart';
import 'package:command_manager/pages/command_manager_page.dart';
import 'package:command_manager/pages/settings_page.dart';
import 'package:command_manager/viewmodels/command_manager_viewmodel.dart';
import 'package:command_manager/viewmodels/locale_viewmodel.dart';
import 'package:command_manager/viewmodels/theme_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:system_tray/system_tray.dart';

Future<void> initSystemTray() async {
  String path =
      Platform.isWindows ? 'assets/app_icon.ico' : 'assets/app_icon.png';

  final AppWindow appWindow = AppWindow();
  final SystemTray systemTray = SystemTray();

  // We first init the systray menu
  await systemTray.initSystemTray(
    title: "system tray",
    iconPath: path,
  );

  // create context menu
  final Menu menu = Menu();
  await menu.buildFrom([
    MenuItemLabel(label: 'Show', onClicked: (menuItem) => appWindow.show()),
    MenuItemLabel(label: 'Hide', onClicked: (menuItem) => appWindow.hide()),
    MenuItemLabel(label: 'Exit', onClicked: (menuItem) => appWindow.close()),
  ]);

  // set context menu
  await systemTray.setContextMenu(menu);

  // handle system tray event
  systemTray.registerSystemTrayEventHandler((eventName) {
    debugPrint("eventName: $eventName");
    if (eventName == kSystemTrayEventClick) {
      Platform.isWindows ? appWindow.show() : systemTray.popUpContextMenu();
    } else if (eventName == kSystemTrayEventRightClick) {
      Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.show();
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSystemTray();

  final themeViewModel = ThemeViewModel();
  final localeViewModel = LocaleViewModel();
  await themeViewModel.load();
  await localeViewModel.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeViewModel),
        ChangeNotifierProvider(create: (_) => localeViewModel),
        ChangeNotifierProvider(create: (_) => CommandManagerViewModel())
      ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> nestedNavigatorKey =
    GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();
    final localeViewModel = context.watch<LocaleViewModel>();
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'command_manager',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'NotoSansSC',
          colorScheme: ColorScheme.fromSeed(seedColor: themeViewModel.color
              // ??const Color.fromARGB(255, 21, 255, 25),
              ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: localeViewModel.locale, // 如果你支持动态切换语言
        home: const HomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0; // 当前选中的索引
  final List<Widget> pages = const [
    CommandManagerPage(),
    RunningCommandsPage(),
    FinishedCommandsPage(),
    SettingsPage(), // Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              if (index == currentIndex) return;
              setState(() {
                currentIndex = index;
              });
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.terminal),
                label: Text('Command Manager'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.play_arrow),
                label: Text('Running'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.done),
                label: Text('Finished'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: pages,
            ),
          ),
        ],
      ),
    );
  }
}
