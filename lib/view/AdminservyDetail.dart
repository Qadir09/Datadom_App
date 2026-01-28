import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminSurveyDetails extends StatelessWidget {
  final QueryDocumentSnapshot doc;

  const AdminSurveyDetails({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final List questions = doc['questions'];

    return Scaffold(
      appBar: AppBar(title: Text(doc['surveyTitle'])),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q${q['number']}: ${q['text']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Type: ${q['type']}'),
                  if ((q['options'] as List).isNotEmpty)
                    Text('Options: ${q['options'].join(', ')}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
