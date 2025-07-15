class CommandAction {
  String name; // 指令名
  String description; // 描述
  List<String> commands; // 命令行命令

  CommandAction({
    required this.name,
    required this.description,
    required this.commands,
  });

  factory CommandAction.fromJson(Map<String, dynamic> json) => CommandAction(
        name: json['name'],
        description: json['description'],
        commands: List<String>.from(json['commands']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'commands': commands,
      };
}
