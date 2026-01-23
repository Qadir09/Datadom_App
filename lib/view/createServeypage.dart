import 'package:flutter/material.dart';

class Createserveypage extends StatelessWidget {
  const Createserveypage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Survey',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: const QuestionList(),
      ),
    );
  }
}

class QuestionList extends StatefulWidget {
  const QuestionList({Key? key}) : super(key: key);

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  List<Question> questions = [Question(number: 1)];
  final TextEditingController surveyTitleController = TextEditingController();

  @override
  void dispose() {
    surveyTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: surveyTitleController,
            decoration: const InputDecoration(
              labelText: 'Survey Title',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return QuestionCard(
                question: questions[index],
                onAdd: () {
                  setState(() {
                    questions.add(Question(number: questions.length + 1));
                  });
                },
                onRemove: () {
                  setState(() {
                    questions.removeAt(index);
                  });
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              // Handle submit action
              print('Survey Title: ${surveyTitleController.text}');
              for (var question in questions) {
                print('Question ${question.number}: ${question.text}');
                print('Type: ${question.type}');
                if (question.options.isNotEmpty) {
                  print('Options: ${question.options}');
                }
              }
            },
            child: const Text('Submit'),
          ),
        ),
      ],
    );
  }
}

class Question {
  int number;
  String text = '';
  String type = 'Text'; // Default question type
  List<String> options = [];

  Question({required this.number});
}

class QuestionCard extends StatefulWidget {
  final Question question;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  void _addOption() {
    setState(() {
      widget.question.options.add('');
    });
  }

  void _removeOption(int index) {
    setState(() {
      widget.question.options.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${widget.question.number}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) => widget.question.text = value,
              decoration: const InputDecoration(
                labelText: 'Type your question...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: widget.question.type,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    widget.question.type = value;
                    if (value != 'Multiple Choice') {
                      widget.question.options
                          .clear(); // Clear options for non-multiple-choice types
                    }
                  });
                }
              },
              items: ['Text', 'Multiple Choice', 'Rating'].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            if (widget.question.type == 'Multiple Choice')
              Column(
                children: [
                  ...widget.question.options.asMap().entries.map((entry) {
                    int index = entry.key;
                    String option = entry.value;
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              widget.question.options[index] = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Option ${index + 1}',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeOption(index),
                        ),
                      ],
                    );
                  }).toList(),
                  TextButton(
                    onPressed: _addOption,
                    child: const Text(
                      'Add Option',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: widget.onAdd,
                  child: const Text(
                    'Add',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: widget.onRemove,
                  child: const Text('Remove',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
