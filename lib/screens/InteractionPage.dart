import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ApplyYC/variables.dart' as variables;
import 'dart:html' as html;
import 'package:firebase_auth/firebase_auth.dart';

class Interactionpage extends StatefulWidget {
  const Interactionpage({super.key});

  @override
  State<Interactionpage> createState() => _InteractionpageState();
}

class _InteractionpageState extends State<Interactionpage> {
  bool errorText = false;
  bool isLoading = false;
  void initState() {
    super.initState();
    errorText = false;
  }

  String? selectedQuestion;
  final TextEditingController inputController = TextEditingController();
  String outputText = "";

  final userId = variables.userData!['email'];

  void _handleSubmit() async {
    if (inputController.text.length > 0) {
      if (variables.userData!['messagesSent'] <
          variables.userData!['totalMessages']) {
        try {
          setState(() {
            isLoading = true;
            outputText =
                "You selected: $selectedQuestion\nYou entered: ${inputController.text}";
          });
          // Save the data to Firestore
          await _saveToFirestore();

          FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
          variables.userData!['messagesSent']++;
          await _firestoreInstance
              .collection('userDB')
              .doc(variables.activeUser!.id)
              .update({'messagesSent': variables.userData!['messagesSent']});

          setState(() {
            isLoading = false;
          });
        } catch (e) {
          print("Error $e");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        _alert();
      }
      errorText = false;
    } else {
      setState(() {
        errorText = true;
      });
    }
  }

  final String stripeUrl =
      "https://create-checkout-session-mad2rp6oyq-uc.a.run.app/create-checkout-session?userID=";

  void _alert() {
    final url = '$stripeUrl${Uri.encodeComponent(userId)}';

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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
                onPressed: () {
                  html.window.open(url, '_blank');
                },
                child: Text("Subscribe now!"))
          ],
        );
      },
    );
  }

  Future<void> _saveToFirestore() async {
    if (selectedQuestion != null && inputController.text.isNotEmpty) {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Reference to the user's document in the messages collection
        DocumentReference userDocRef =
            firestore.collection('messages').doc(userId);

        // Check if the document exists
        DocumentSnapshot docSnapshot = await userDocRef.get();

        // Define the new message to add
        Map<String, dynamic> newMessage = {
          'request': selectedQuestion! + inputController.text,
          'response': '',
          // 'timestamp': Timestamp.now(),
        };

        if (docSnapshot.exists) {
          // If the document exists, update it with the new message
          await userDocRef.update({
            'messages': FieldValue.arrayUnion([newMessage])
          });
        } else {
          // If the document doesn't exist, create it with the new message
          print("Creating new document");
          await userDocRef.set({
            'messages': [newMessage]
          });
          await userDocRef.set({
            'messages': [newMessage, newMessage]
          });
          // Refresh the page after creating the new document
        }

        DocumentSnapshot doc = await userDocRef.get();

        // Extract the last response from the messages array
        List<dynamic> messages = doc['messages'];
        if (messages.isNotEmpty) {
          Map<String, dynamic> lastMessage = messages.last;
          setState(() {
            outputText = lastMessage['response'];
          });
        }

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'ApplyYC',
          style: TextStyle(fontSize: 32, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                      items: variables.questions
                          .map<DropdownMenuItem<String>>((String value) {
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
                          padding: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 33),
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
                        if (errorText)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "Please enter your input text",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        Container(
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
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
                if (variables.userData!['messagesSent'] > 0)
                  isLoading
                      ? CircularProgressIndicator()
                      : StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('messages')
                              .doc(userId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }

                            var userDoc = snapshot.data;
                            var messages =
                                userDoc!['messages'] as List<dynamic>;
                            var lastMessage = messages.isNotEmpty
                                ? messages.last
                                : {'response': ''};

                            return Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SelectableText(
                                lastMessage['response'],
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          },
                        ),
                Text(
                  "Total messages: ${variables.userData!['messagesSent'] ?? 0}/${variables.userData!['totalMessages']}",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
