import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/todo_model.dart';
import '../../providers/todo_provider.dart';

class ProgresstTab extends StatefulWidget {
  @override
  _ProgresstTabState createState() => _ProgresstTabState();
}

class _ProgresstTabState extends State<ProgresstTab> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    Future.delayed(Duration.zero, () {
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      final incompleteTodos = todoProvider.inProgress;
      if (incompleteTodos.length < 15 && todoProvider.hasMore) {
        //todoProvider.loadMoreInProgress();
      }
    });
  }

  void _scrollListener() {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        todoProvider.hasMore) {
      //todoProvider.loadMoreInProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        final incompleteTodos = todoProvider.inProgress;

        return ListView.builder(
          controller: _scrollController,
          itemCount: incompleteTodos.length,
          itemBuilder: (context, index) {
            if (index == incompleteTodos.length) {
              return todoProvider.hasMore
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox();
            }
            final todo = incompleteTodos[index];

            return Dismissible(
              key: Key(todo.id.toString()), // Unique key for each item
              direction: DismissDirection.endToStart, // Swipe left to delete
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                // Call provider to delete the item
                Provider.of<TodoProvider>(context, listen: false).deleteTodo(todo.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Task deleted"), duration: Duration(seconds: 2)),
                );
              },
              child: ListTile(
                title: Text(todo.title),
                subtitle: Row(
                  children: [
                    Text("Priority: ${todo.priority}"),
                    SizedBox(width: 10),
                    Text("Assignee: UserId${todo.userId}"),
                  ],
                ),
                leading: Icon(Icons.task_alt, color: Colors.blueAccent),
                trailing: InkWell(
                  child: Icon(Icons.edit, color: Colors.black),
                  onTap: (){
                    _showEditDialog(context, todo,todoProvider);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, TodoModel todo,TodoProvider provider) {
    TextEditingController titleController = TextEditingController(text: todo.title);
    String selectedStatus = todo.completed ? "Completed" : (todo.inProgress ? "In Progress" : "To-Do");
    String selectedPriority = todo.priority;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Task Description"),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: ["To-Do", "In Progress", "Completed"]
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  selectedStatus = value!;
                },
                decoration: InputDecoration(labelText: "Status"),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                items: ["high", "medium", "low"]
                    .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                ))
                    .toList(),
                onChanged: (value) {
                  selectedPriority = value!;
                },
                decoration: InputDecoration(labelText: "Priority"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                provider.updateTodo(context, todo, titleController.text, selectedStatus, selectedPriority,todo.id);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
