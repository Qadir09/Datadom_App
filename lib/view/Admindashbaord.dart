import 'package:datadom/view/Adminmanagement.dart';
import 'package:datadom/view/UserInfo.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Admin',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Survey Management Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllUsers()),
                  );
                },
                child: const Text('Manage User Data'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to User Management Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageSurveysPage()),
                  );
                },
                child: const Text('Manage Surveys'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
