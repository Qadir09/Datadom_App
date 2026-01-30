import 'package:datadom/view/AdminservyDetail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'admin_view_surveys.dart'; // <-- contains AdminSurveyDetails

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  // ---------------- Fetch All Users ----------------
  Future<List<QueryDocumentSnapshot>> _fetchAllUsers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('user_detail').get();
    return snapshot.docs;
  }

  // ---------------- Fetch Surveys Of Specific User ----------------
  Future<List<QueryDocumentSnapshot>> _fetchUserSurveys(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('surveys')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _fetchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userId = user.id;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text(
                    "${user['firstName']} ${user['lastName']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Email: ${user['email']}"),
                  children: [
                    FutureBuilder<List<QueryDocumentSnapshot>>(
                      future: _fetchUserSurveys(userId),
                      builder: (context, surveySnapshot) {
                        if (surveySnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (surveySnapshot.hasError) {
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Error loading surveys",
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        if (!surveySnapshot.hasData ||
                            surveySnapshot.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("No surveys uploaded"),
                          );
                        }

                        final surveys = surveySnapshot.data!;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: surveys.length,
                          itemBuilder: (context, i) {
                            final survey = surveys[i];

                            return ListTile(
                              leading: const Icon(Icons.poll),
                              title: Text("Survey: ${survey['surveyTitle']}"),
                              subtitle: Text("Tap to view full survey"),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminSurveyDetails(doc: survey),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
