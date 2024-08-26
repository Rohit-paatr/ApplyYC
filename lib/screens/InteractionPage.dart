import 'package:ApplyYC/screens/subscribeDialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ApplyYC/variables.dart' as variables;
import 'package:url_launcher/url_launcher.dart';

class Interactionpage extends StatefulWidget {
  const Interactionpage({super.key});

  @override
  State<Interactionpage> createState() => _InteractionpageState();
}

class _InteractionpageState extends State<Interactionpage> {
  void initState() {
    super.initState();
    if (!variables.userData!['paid']) {
      _alert();
    }
  }

  String? selectedQuestion;
  final TextEditingController inputController = TextEditingController();
  String outputText = "";

  List<String> questions = [
    "If you had any other ideas you considered applying with, please list them. One may be something we've been waiting for. Often when we fund people it's to do something they list here and not in the main application.",
    "What do you do?",
    "Where are you from?",
  ];

  void _handleSubmit() async {
    if (variables.userData!['messagesSent'] <
        variables.userData!['totalMessages']) {
      try {
        setState(() {
          outputText =
              "You selected: $selectedQuestion\nYou entered: ${inputController.text}";
        }); // Save the data to Firestore
        await _saveToFirestore();

        // Send the data to the webhook
        // await _sendToWebhook();

        FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
        variables.userData!['messagesSent']++;
        await _firestoreInstance
            .collection('userDB')
            .doc(variables.activeUser!.id)
            .update({'messagesSent': variables.userData!['messagesSent']});

        setState(() {});
      } catch (e) {
        print("Error $e");
      }
    } else {
      _alert();
    }
  }

  final String stripeUrl =
      "https://create-checkout-session-mad2rp6oyq-uc.a.run.app/create-checkout-session?userID=";

  void _launchStripe(BuildContext context) async {
    final userId =
        variables.userData!['email']; // Replace with the actual user ID
    final url = '$stripeUrl${Uri.encodeComponent(userId)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch Stripe')),
      );
    }
  }

  void _alert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Subscribe for More Messages'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Subscribe now for \$9.99 and get 200 more messages to use on our platform.'),
              SizedBox(height: 20),
              // Image.network('https://i.imgur.com/EHyR2nP.png',
              //     height: 100), // Example product image
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _launchStripe(context); // Redirect to Stripe
              },
              child: Text('Subscribe Now'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendToWebhook() async {
    if (selectedQuestion != null && inputController.text.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse(
              'https://hook.us2.make.com/1n3ypkqopmq1bel8uwks7n0budunr0ih'),
          headers: {'Content-Type': 'application/json'},
          body: '''{
           'path':'/messages/${variables.activeDocID}'
          }''',
        );
        // "question": "$selectedQuestion",
        // "response": "${inputController.text}"'

        if (response.statusCode == 200) {
          print("Data sent to webhook successfully");
        } else {
          print("Failed to send data to webhook: ${response.statusCode}");
        }
      } catch (e) {
        print("Error sending data to webhook: $e");
      }
    } else {
      print("Question or response is empty");
    }
  }

  Future<void> _saveToFirestore() async {
    if (selectedQuestion != null && inputController.text.isNotEmpty) {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Create a new document in Firestore
        DocumentReference docRef = await firestore.collection('messages').add({
          'question': selectedQuestion,
          'user': inputController.text,
          'agent': '',
          'path': '',
          'timestamp': Timestamp.now(),
        });
        await docRef.update({
          'path': '/messages/${docRef.id}',
        });

        print("Data saved to Firestore");
      } catch (e) {
        print("Error saving data to Firestore: $e");
      }
    } else {
      print("Question or response is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!variables.userData!['paid']) {
      _alert();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'ApplyYC',
          style: TextStyle(fontSize: 32, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Container(
                  child: DropdownButton<String>(
                    value: selectedQuestion,
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                    dropdownColor: Colors.grey[700],
                    hint: Text(
                      "Select a question",
                      style: TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedQuestion = newValue;
                      });
                    },
                    items:
                        questions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8 - 50,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: inputController,
                maxLines: 5,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter your response",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: _handleSubmit,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        margin: EdgeInsets.all(10),
                        padding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 33),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Righteous',
                                  fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.all(10),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Righteous',
                                  fontSize: 24),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  outputText,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text(
                "Total messages: ${variables.userData!['messagesSent'] ?? 0}/${variables.userData!['totalMessages']}",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
