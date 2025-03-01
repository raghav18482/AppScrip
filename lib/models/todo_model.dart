class TodoModel {
  final int id;
  final int userId;
  final String title;
  final bool completed;
  final String priority; // New field
  final bool inProgress; // New field

  TodoModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
    this.priority = 'low',  // Default value
    this.inProgress = false, // Default value
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  factory TodoModel.fromMap(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'] == 1,
      priority: json['priority'] ?? 'low',
      inProgress: json['inProgress'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'completed': completed ? 1 : 0,
      'priority': priority,
      'inProgress': inProgress ? 1 : 0,
    };
  }
}
