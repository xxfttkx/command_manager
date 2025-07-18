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
  String get addCommand => '新增命令';

  @override
  String get editCommand => '编辑命令';

  @override
  String get nameLabel => '名称';

  @override
  String get descriptionLabel => '描述';

  @override
  String get commandsLabel => '命令（每行一条）';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get nameAndCommandsRequired => '名称和命令不能为空';

  @override
  String get searchCommand => '搜索命令名或内容';

  @override
  String get noMatchedCommand => '无匹配命令';

  @override
  String get deleteConfirmTitle => '确认删除';

  @override
  String get deleteConfirmContent => '你确定要删除这个命令吗？此操作无法撤销。';

  @override
  String deleteSuccessMessage(Object commandName) {
    return '命令 \"$commandName\" 已成功删除。';
  }

  @override
  String get addCommandTooltip => '添加命令';

  @override
  String saveSuccessMessage(Object commandName) {
    return '命令 \"$commandName\" 保存成功。';
  }

  @override
  String duplicateCommandMessage(Object commandName) {
    return '已存在同名命令 \"$commandName\"。';
  }

  @override
  String startCommand(Object commandName) {
    return '开始运行命令 “$commandName”';
  }

  @override
  String endCommand(Object commandName) {
    return '命令 “$commandName” 运行完毕';
  }

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
  String get finishedCommands => '已完成的命令';

  @override
  String get noFinishedCommands => '暂无已完成的命令';

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
