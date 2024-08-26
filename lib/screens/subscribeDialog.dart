// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SubscriptionDialog extends StatelessWidget {
 

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Subscribe for More Messages'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//               'Subscribe now and get 200 free messages to use on our platform.'),
//           SizedBox(height: 20),
//           Image.network('https://i.imgur.com/EHyR2nP.png',
//               height: 100), // Example product image
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () => _launchStripe(context),
//           child: Text('Subscribe Now'),
//         ),
//       ],
//     );
//   }
// }
