import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  Future<List<Map<String, dynamic>>> _fetchAllUsers() async {
    try {
      final userSnapshot =
          await FirebaseFirestore.instance.collection('user_detail').get();
      return userSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch users: $e");
    }
  }

  Future<List<Map<String, dynamic>>> _fetchUserSurveys(String userId) async {
    try {
      final surveySnapshot = await FirebaseFirestore.instance
          .collection('surveys')
          .where('userId', isEqualTo: userId)
          .get();

      return surveySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch surveys: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text(
                      "${user['firstName']} ${user['lastName']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Email: ${user['email']}"),
                    children: [
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _fetchUserSurveys(user['id']),
                        builder: (context, surveySnapshot) {
                          if (surveySnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            );
                          } else if (surveySnapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Error loading surveys",
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          } else if (surveySnapshot.hasData &&
                              surveySnapshot.data!.isNotEmpty) {
                            final surveys = surveySnapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: surveys.length,
                              itemBuilder: (context, surveyIndex) {
                                final survey = surveys[surveyIndex];
                                return ListTile(
                                  leading: const Icon(Icons.poll),
                                  title: Text("Survey: ${survey['title']}"),
                                  subtitle: Text(
                                    "Description: ${survey['description'] ?? 'No description provided'}",
                                  ),
                                  trailing: Text(
                                    "Created: ${survey['created_at']?.toDate().toString() ?? 'Unknown'}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("No surveys uploaded"),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("No users found"),
            );
          }
        },
      ),
    );
  }
}
