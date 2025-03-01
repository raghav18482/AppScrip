import 'package:demo/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../providers/todo_provider.dart';
import 'dashboard_tabs/completed.dart';
import 'dashboard_tabs/progress.dart';
import 'dashboard_tabs/todo.dart';

class HomePage extends StatefulWidget {
  final int userId;
  const HomePage({super.key, required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final profileProvider =
      Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.loadProfile(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Tasks Manager"),
          actions: [
            Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
                return CircleAvatar(
                  radius: 27,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId,)),
                        );
                      },
                      child: SizedBox(
                          width: 36.0,
                          height: 36.0,
                          child: profileProvider.profile != null
                              ? Image.network(
                            profileProvider.profile!.avatar,
                            fit: BoxFit.fill,
                            errorBuilder: (context, obj, strace) {
                              return Icon(Icons.account_circle);
                            },
                          )
                              : null),
                    ),
                  ),
                );
              }
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: "To-Do"),
              Tab(text: "In Progress"),
              Tab(text: "Completed"),
            ],
            onTap: (index){
              final todoProvider = Provider.of<TodoProvider>(context, listen: false);
              if(index==0){
                if (todoProvider.todos.isEmpty && todoProvider.hasMore) {
                  todoProvider.loadMoreCompleted();
                }
              }
              if(index==1) {
                todoProvider.loadMoreInProgress();
              }
              if(index==2){
                if (todoProvider.completed.isEmpty && todoProvider.hasMore) {
                  todoProvider.loadMoreCompleted();
                }
              }
            },
          ),
        ),
        body:  TabBarView(
          children: [
            TodoListTab(),
            ProgresstTab(),
            CompletedTab(),
          ],
        ),
      ),
    );
  }
}
