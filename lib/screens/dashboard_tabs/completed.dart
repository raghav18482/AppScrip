import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/todo_provider.dart';

class CompletedTab extends StatefulWidget {
  @override
  _CompletedTabState createState() => _CompletedTabState();
}

class _CompletedTabState extends State<CompletedTab> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    //Automatically load more if the list is small at start
    Future.delayed(Duration.zero, () {
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      final completedTodos = todoProvider.completed.where((todo) => todo.completed).toList();
      if (completedTodos.length < 15 && todoProvider.hasMore) {
        todoProvider.loadMoreCompleted();
      }
    });
  }

  void _scrollListener() {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    //Fetch more if scrolled to bottom and more data is available
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        todoProvider.hasMore) {
      todoProvider.loadMoreCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        final completedTodos = todoProvider.completed.where((todo) => todo.completed).toList();

        return ListView.builder(
          controller: _scrollController,
          itemCount: completedTodos.length + (todoProvider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == completedTodos.length) {
              return todoProvider.hasMore
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox();
            }
            final todo = completedTodos[index];
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
                Provider.of<TodoProvider>(context, listen: false).deleteCompleted(todo.id);
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
                leading: Icon(Icons.task_alt, color: Colors.green),
              ),
            );
          },
        );
      },
    );
  }
}
