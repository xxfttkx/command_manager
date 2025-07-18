import 'package:command_manager/pages/running_commands_page.dart';
import 'package:command_manager/pages/command_manager_page.dart';
import 'package:command_manager/pages/settings_page.dart';
import 'package:command_manager/viewmodels/command_manager_viewmodel.dart';
import 'package:command_manager/viewmodels/locale_viewmodel.dart';
import 'package:command_manager/viewmodels/theme_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeVM = ThemeViewModel();
  final localeVM = LocaleViewModel();
  await themeVM.load();
  await localeVM.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeVM),
        ChangeNotifierProvider(create: (_) => localeVM),
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
    final theme = context.watch<ThemeViewModel>();
    final locale = context.watch<LocaleViewModel>();
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'command_manager',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'NotoSansSC',
          colorScheme: ColorScheme.fromSeed(seedColor: theme.color
              // ??const Color.fromARGB(255, 21, 255, 25),
              ),
        ),
        locale: locale.locale,
        supportedLocales: const [Locale('en'), Locale('zh')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
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
