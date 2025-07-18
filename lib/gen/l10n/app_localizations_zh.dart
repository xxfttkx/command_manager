// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '命令管理器';

  @override
  String get run => '运行';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get runningCommands => '正在运行的命令';

  @override
  String get noRunningCommands => '暂无正在运行的命令';

  @override
  String get startTime => '启动时间';

  @override
  String get terminateProcess => '终止进程';

  @override
  String get tabSettings => '设置';

  @override
  String get themeColor => '主题颜色';

  @override
  String get language => '语言';
}
