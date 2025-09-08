import 'package:api_profile_view/screens/user_profile.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../widgets/loading_error.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      users = await ApiService.fetchUsers();
    } catch (e) {
      error = e.toString();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users"),
      backgroundColor: Colors.blue,),
      body: isLoading || error != null
          ? LoadingErrorWidget(
        isLoading: isLoading,
        errorMessage: error,
        onRetry: fetchData,
      )
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
            ),
            title: Text(user.name),
            subtitle: Text(user.email),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserProfileScreen(userId: user.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: !isLoading && error == null
          ? FloatingActionButton(
        onPressed: fetchData,
        child: const Icon(Icons.refresh),
      )
          : null,
    );
  }
}
