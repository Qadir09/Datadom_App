import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  final String surveyTitle;

  SurveyPage({required this.surveyTitle});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  late List<Map<String, dynamic>> questions;
  List<String> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    // Initialize questions based on survey title
    switch (widget.surveyTitle) {
      case 'Education Survey':
        questions = EducationSurvey.questions;
        break;
      case 'Impact of Internet':
        questions = InternetImpactSurvey.questions;
        break;
      case 'Social Media Impact on Students':
        questions = SocialMediaImpactSurvey.questions;
        break;
      case 'City Lifestyle Survey':
        questions = CityLifestyleSurvey.questions;
        break;
      default:
        questions = [];
    }
    selectedAnswers =
        List.filled(questions.length, ''); // Initialize answers list
  }

  // Submit responses to Firestore
  // Submit responses to Firestore
  Future<void> submitResponses() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in. Please log in to submit.')),
      );
      return;
    }

    String uid = user.uid; // Unique user identifier

    try {
      // Save responses with UID as part of the data
      await FirebaseFirestore.instance.collection('survey_responses').add({
        'userId': uid,
        'userEmail': user.email, // Optional: Store email for reference
        'surveyTitle': widget.surveyTitle,
        'responses': selectedAnswers,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Survey Submitted Successfully!')),
      );

      Navigator.pop(context); // Go back to the survey list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.surveyTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  var question = questions[index];
                  return QuestionWidget(
                    questionText: question['question'],
                    options: question['options'],
                    onChanged: (value) {
                      setState(() {
                        selectedAnswers[index] = value!;
                      });
                    },
                    selectedAnswer: selectedAnswers[index],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: submitResponses,
              child: Text('Submit Responses'),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget for displaying a question

class QuestionWidget extends StatelessWidget {
  final String questionText;
  final List<String> options;
  final String selectedAnswer;
  final ValueChanged<String?> onChanged; // Update to String?

  QuestionWidget({
    required this.questionText,
    required this.options,
    required this.selectedAnswer,
    required this.onChanged, // This will now accept nullable String?
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(questionText, style: TextStyle(fontSize: 18)),
        ...options.map((option) {
          return RadioListTile<String?>(
            // Update to String? for the value type
            title: Text(option),
            value: option,
            groupValue: selectedAnswer,
            onChanged: (String? value) {
              // Make this value nullable (String?)
              onChanged(value); // Pass the nullable value
            },
          );
        }).toList(),
      ],
    );
  }
}

// Education Survey Questions
class EducationSurvey {
  static const List<Map<String, dynamic>> questions = [
    {
      'question': 'What is your preferred method of learning?',
      'options': ['Online', 'In-person', 'Hybrid']
    },
    {
      'question': 'Do you feel online education is as effective as in-person?',
      'options': ['Yes', 'No', 'Not Sure']
    },
    {
      'question':
          'How many hours do you spend on educational activities daily?',
      'options': ['0-2', '3-5', '6-8', '9+']
    },
    {
      'question': 'Do you think the education system is outdated?',
      'options': ['Yes', 'No', 'Unsure']
    },
    {
      'question': 'Have you used any online platforms for learning?',
      'options': ['Yes', 'No']
    },
    {
      'question': 'Do you think technology helps students learn better?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question': 'Should education be free for all?',
      'options': ['Yes', 'No', 'Depends on the subject']
    },
    {
      'question': 'How often do you use the internet for educational purposes?',
      'options': ['Daily', 'Weekly', 'Occasionally', 'Never']
    },
    {
      'question': 'What is your main source of learning materials?',
      'options': ['Books', 'Internet', 'Classroom', 'Other']
    },
    {
      'question':
          'Do you think the education system prepares students for real-life challenges?',
      'options': ['Yes', 'No', 'Not Sure']
    },
    {
      'question':
          'How important do you think extracurricular activities are in education?',
      'options': ['Very Important', 'Somewhat Important', 'Not Important']
    },
    {
      'question':
          'Should schools teach life skills (e.g., financial literacy, communication)?',
      'options': ['Yes', 'No']
    },
  ];
}

// Impact of Internet Survey Questions
class InternetImpactSurvey {
  static const List<Map<String, dynamic>> questions = [
    {
      'question': 'How many hours do you spend on the internet daily?',
      'options': ['0-2', '3-5', '6-8', '9+']
    },
    {
      'question':
          'Do you think the internet has a positive impact on your life?',
      'options': ['Yes', 'No', 'Neutral']
    },
    {
      'question': 'Do you use the internet for educational purposes?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question':
          'Do you think excessive internet use affects your productivity?',
      'options': ['Yes', 'No', 'Not Sure']
    },
    {
      'question':
          'Do you feel that the internet has made communication easier?',
      'options': ['Yes', 'No', 'Somewhat']
    },
    {
      'question': 'Has the internet improved your job prospects?',
      'options': ['Yes', 'No', 'Not Sure']
    },
    {
      'question':
          'Do you use the internet more for entertainment than for work/study?',
      'options': ['Yes', 'No', 'Equally']
    },
    {
      'question': 'Has the internet made it easier to access information?',
      'options': ['Yes', 'No', 'Not Sure']
    },
    {
      'question':
          'Do you feel overwhelmed by the amount of information on the internet?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question':
          'Do you think the internet has a positive or negative effect on social relationships?',
      'options': ['Positive', 'Negative', 'Neutral']
    },
    {
      'question': 'Do you think the internet is addictive?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question': 'Should there be more regulation on internet content?',
      'options': ['Yes', 'No', 'Not Sure']
    },
  ];
}

// Social Media Impact Survey Questions
class SocialMediaImpactSurvey {
  static const List<Map<String, dynamic>> questions = [
    {
      'question': 'How many hours do you spend on social media daily?',
      'options': ['0-2', '3-5', '6-8', '9+']
    },
    {
      'question':
          'Do you think social media has a positive impact on students?',
      'options': ['Yes', 'No', 'Neutral']
    },
    {
      'question': 'Do you think social media affects academic performance?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question': 'Do you use social media for educational purposes?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question': 'Does social media distract you from your studies?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question': 'Do you think social media helps students stay connected?',
      'options': ['Yes', 'No', 'Not Sure']
    },
    {
      'question':
          'Have you ever felt stressed or anxious because of social media?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question': 'Do you think social media affects mental health?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question': 'Should schools regulate social media usage among students?',
      'options': ['Yes', 'No', 'Not Sure']
    },
    {
      'question': 'Do you think social media encourages unhealthy comparisons?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question': 'Has social media been a source of motivation for you?',
      'options': ['Yes', 'No', 'Sometimes']
    },
  ];
}

class CityLifestyleSurvey {
  static const List<Map<String, dynamic>> questions = [
    {
      'question': 'Do you prefer living in a city or a rural area?',
      'options': ['City', 'Rural Area', 'No Preference']
    },
    {
      'question': 'How often do you experience traffic congestion in the city?',
      'options': ['Daily', 'Weekly', 'Rarely', 'Never']
    },
    {
      'question': 'Do you think city living is stressful?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question':
          'Do you think city living is more expensive than rural living?',
      'options': ['Yes', 'No', 'Depends on the city']
    },
    {
      'question':
          'Do you have easy access to public transportation in the city?',
      'options': ['Yes', 'No']
    },
    {
      'question': 'Do you feel safe living in the city?',
      'options': ['Yes', 'No', 'Depends on the area']
    },
    {
      'question': 'Do you enjoy the nightlife in the city?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question': 'How often do you interact with your neighbors in the city?',
      'options': ['Daily', 'Weekly', 'Rarely', 'Never']
    },
    {
      'question':
          'Do you think cities offer more opportunities for career growth?',
      'options': ['Yes', 'No', 'Depends on the industry']
    },
    {
      'question':
          'Do you think the pollution levels in cities affect your health?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question':
          'Do you prefer a fast-paced lifestyle or a slower, rural lifestyle?',
      'options': ['Fast-paced', 'Slower', 'No Preference']
    },
    {
      'question':
          'Do you think cities are more socially connected than rural areas?',
      'options': ['Yes', 'No', 'Sometimes']
    },
    {
      'question': 'Would you ever consider moving to a rural area?',
      'options': ['Yes', 'No', 'Maybe']
    },
  ];
}
