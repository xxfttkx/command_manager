import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:command_manager/pages/finished_commands_page.dart';
import 'package:command_manager/pages/running_commands_page.dart';
import 'package:command_manager/pages/command_manager_page.dart';
import 'package:command_manager/pages/settings_page.dart';
import 'package:command_manager/viewmodels/command_manager_viewmodel.dart';
import 'package:command_manager/viewmodels/settings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

class MyWindowListener extends WindowListener {
  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      // 拦截关闭事件，隐藏窗口（最小化到托盘）
      await windowManager.hide();
    }
  }
}

Future<void> initWindowManager() async {
  // 初始化 window_manager
  await windowManager.ensureInitialized();

  // 设置初始窗口大小
  await windowManager.setSize(const Size(1280, 720));

  // 将窗口置于屏幕中央
  await windowManager.setAlignment(Alignment.center);

  // 可选：显示窗口
  // await windowManager.show();
  // await windowManager.focus();
  // await windowManager.setAlwaysOnTop(true);
  // await Future.delayed(const Duration(milliseconds: 100));
  // await windowManager.setAlwaysOnTop(false); // 强制拉到前台

  // 设置窗口为可关闭监听
  windowManager.setPreventClose(true); // 重要！

  // 监听关闭事件
  windowManager.addListener(MyWindowListener());
}

Future<void> initSystemTray() async {
  String path =
      Platform.isWindows ? 'assets/app_icon.ico' : 'assets/app_icon.png';

  final SystemTray systemTray = SystemTray();

  // We first init the systray menu
  await systemTray.initSystemTray(
    title: "system tray",
    iconPath: path,
  );

  // create context menu
  final Menu menu = Menu();
  await menu.buildFrom([
    MenuItemLabel(label: 'Show', onClicked: (menuItem) => windowManager.show()),
    MenuItemLabel(label: 'Hide', onClicked: (menuItem) => windowManager.hide()),
    MenuItemLabel(
        label: 'Exit', onClicked: (menuItem) => windowManager.destroy()),
  ]);

  // set context menu
  await systemTray.setContextMenu(menu);

  // handle system tray event
  systemTray.registerSystemTrayEventHandler((eventName) {
    debugPrint("eventName: $eventName");
    if (eventName == kSystemTrayEventClick) {
      Platform.isWindows ? windowManager.show() : systemTray.popUpContextMenu();
    } else if (eventName == kSystemTrayEventRightClick) {
      Platform.isWindows ? systemTray.popUpContextMenu() : windowManager.show();
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSystemTray();
  await initWindowManager();

  final settingsViewModel = SettingsViewModel();
  await settingsViewModel.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settingsViewModel),
        ChangeNotifierProvider(
            create: (_) => CommandManagerViewModel(settings: settingsViewModel))
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
    final settingsViewModel = context.watch<SettingsViewModel>();
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'command_manager',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'NotoSansSC',
          colorScheme: ColorScheme.fromSeed(seedColor: settingsViewModel.color
              // ??const Color.fromARGB(255, 21, 255, 25),
              ),
          textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: 1.0, // 缩放字体大小
              ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: settingsViewModel.locale, // 如果你支持动态切换语言
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
