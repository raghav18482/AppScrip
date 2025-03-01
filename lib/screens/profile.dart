import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile_model.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../services/common_services.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({super.key, required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final userProvider = Provider.of<ProfileProvider>(context, listen: false);

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      if (!userProvider.isLoading && userProvider.currentPage < userProvider.totalPages) {
        userProvider.fetchUsers(userProvider.currentPage + 1);
      }
    }
  }

  Future<void> init() async{
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.isLoading = true;
    Future.microtask(() async {
      // Create the Futures
      final loadProfileFuture = profileProvider.loadProfile(widget.userId);
      final fetchUsersFuture = profileProvider.fetchUsers(1);

      // Run them in parallel using Future.wait
      await Future.wait([loadProfileFuture, fetchUsersFuture]).then((id){
        profileProvider.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (profileProvider.error != null) {
            return Center(child: Text("Error: ${profileProvider.error}", style: TextStyle(color: Colors.red)));
          } else if (profileProvider.profile != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profileProvider.profile!.avatar),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${profileProvider.profile!.firstName} ${profileProvider.profile!.lastName}",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(profileProvider.profile!.email, style: TextStyle(fontSize: 16)),
                    Divider(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Other Users Profile",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                        child: Row(
                          children: [
                            ...profileProvider.users.map((user) => UserCard(user: user)).toList(),
                            if (profileProvider.isLoading)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: CircularProgressIndicator(),
                              ),
                          ]
                        ),
                      ),
                      const Divider(),
                      InkWell(
                        onTap: () {
                          authProvider.logout(context);
                        },
                        child: CommonServices().iconLink(Icons.logout, 'Log Out'),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return Center(child: Text("No profile data available"));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class UserCard extends StatelessWidget {
  final ProfileModel user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 200, // Set fixed width for each card
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.avatar),
            ),
            SizedBox(height: 10),
            Text(
              "${user.firstName} ${user.lastName}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              user.email,
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
