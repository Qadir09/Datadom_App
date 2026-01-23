import 'package:datadom/view/createServeypage.dart';
import 'package:flutter/material.dart';
import 'package:datadom/view/Serveypg.dart'; // Your Survey Page
import 'package:datadom/view/Login.dart'; // Your Login Page
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication

class dashboard extends StatefulWidget {
  dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  // List of surveys you want to show
  final List<String> surveyTitles = [
    'Education Survey',
    'Impact of Internet',
    'Social Media Impact on Students',
    'City Lifestyle Survey',
  ];

  // Dropdown related variables
  final List<String> dropdownOptions = [
    'Rewards',
    'User Name',
    'Your Survey',
    'Logout',
    'Get Survey',
  ];
  String selectedOption = 'User Name'; // Ensure this value exists in the list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TheDataDom',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dropdown Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedOption,
                items: dropdownOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (newValue) async {
                  setState(() {
                    selectedOption = newValue!;
                  });

                  if (newValue == 'Get Survey') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Createserveypage(),
                      ),
                    );
                  } else if (newValue == 'Logout') {
                    // Firebase Sign Out (if using Firebase Authentication)
                    try {
                      await FirebaseAuth.instance.signOut();
                    } catch (e) {
                      print('Error signing out: $e');
                    }

                    // Navigate to Login Page
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                      (route) => false,
                    );
                  }
                },
                decoration: InputDecoration(
                  labelText: 'User Info',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),

            // Welcome Section
            SizedBox(
              child: Card(
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Welcome To\n DataDom',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: Text(
                      'A platform for survey-based researches',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Information Section
            Card(
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'For Students and Professionals',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '. Get paid to answer each survey\n. Scholarship/Incentives\n. Get your opinions heard\n. Ambassador programs',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Survey List Section
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Survey Available',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF40C4FF)),
              ),
            ),

            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: surveyTitles.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Color(0xFF40C4FF),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ListTile(
                    title: Center(
                      child: Text(
                        surveyTitles[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    onTap: () {
                      // Navigate to the corresponding survey page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SurveyPage(surveyTitle: surveyTitles[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
