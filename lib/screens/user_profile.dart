import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../widgets/loading_error.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? user;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      user = await ApiService.fetchUserById(widget.userId);
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
      appBar: AppBar(title: const Text("User Profile")),
      body: isLoading || error != null
          ? LoadingErrorWidget(
        isLoading: isLoading,
        errorMessage: error,
        onRetry: fetchUser,
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user!.avatar),
            ),
            const SizedBox(height: 16),
            Text(
              user!.name,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              user!.email,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
