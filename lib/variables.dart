import 'package:google_sign_in/google_sign_in.dart';

GoogleSignInAccount? activeUser;
Map<String, dynamic>? userData;
String? activeDocID;

List<String> questions = [
  "How long have the founders known one another and how did you meet? Have any of the founders not met in person?",
  "Who writes code, or does other technical work on your product? Was any of it done by a non-founder? Please explain.",
  "Describe what your company does in 50 characters or less.",
  "What is your company going to make? Please describe your product and what it does or will do.",
  "Where do you live now, and where would the company be based after YC? Explain your decision regarding location.",
  "How far along are you?",
  "How long have each of you been working on this? How much of that has been full-time? Please explain.",
  "What tech stack are you using, or planning to use, to build this product?",
  "How many active users or customers do you have? How many are paying? Who is paying you the most, and how much do they pay you?",
  "If you are applying with the same idea as a previous batch, did anything change? If you applied with a different idea, why did you pivot and what did you learn from the last idea?",
  "If you have already participated or committed to participate in an incubator, accelerator or pre-accelerator program, please tell us about it.",
  "Why did you pick this idea to work on? Do you have domain expertise in this area? How do you know people need what you're making?",
  "Who are your competitors? What do you understand about your business that they don't?",
  "How do or will you make money? How much could you make?",
  "If you had any other ideas you considered applying with, please list them. One may be something we've been waiting for. Often when we fund people it's to do something they list here and not in the main application.",
  "What convinced you to apply to Y Combinator? Did someone encourage you to apply? Have you been to any YC events?",
  "How did you hear about Y Combinator?",
  "Custom Question",
];

String privacyPolicy = '''
Privacy Policy for ApplyYC (Paatr.ai)

Last updated: 26 August 2024

1. Introduction
Welcome to ApplyYC. We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you about how we look after your personal data when you visit our website and tell you about your privacy rights and how the law protects you.

2. Data We Collect
We may collect, use, store and transfer different kinds of personal data about you which we have grouped together as follows:
- Identity Data: includes first name, last name, username or similar identifier.
- Contact Data: includes email address.
- Technical Data: includes internet protocol (IP) address, your login data, browser type and version, time zone setting and location, browser plug-in types and versions, operating system and platform, and other technology on the devices you use to access this website.
- Usage Data: includes information about how you use our website and services.

3. How We Use Your Data
We will only use your personal data when the law allows us to. Most commonly, we will use your personal data in the following circumstances:
- To provide and maintain our service.
- To notify you about changes to our service.
- To provide customer support.
- To gather analysis or valuable information so that we can improve our service.
- To detect, prevent and address technical issues.

4. Data Security
We have put in place appropriate security measures to prevent your personal data from being accidentally lost, used or accessed in an unauthorized way, altered or disclosed.

5. Data Retention
We will only retain your personal data for as long as reasonably necessary to fulfill the purposes we collected it for, including for the purposes of satisfying any legal, regulatory, tax, accounting or reporting requirements.

6. Your Legal Rights
Under certain circumstances, you have rights under data protection laws in relation to your personal data, including the right to request access, correction, erasure, restriction, transfer, to object to processing, to portability of data and (where the lawful ground of processing is consent) to withdraw consent.

7. Changes to This Privacy Policy
We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

8. Contact Us
If you have any questions about this Privacy Policy, please contact us at: admin@paatr.ai
''';

String termsOfService = '''
Terms of Service for ApplyYC (Paatr.ai)

Last updated: 26 August 2024

1. Acceptance of Terms
By accessing or using ApplyYC (Paatr.ai), you agree to be bound by these Terms of Service. If you disagree with any part of the terms, you may not access the service.

2. Description of Service
ApplyYC provides a platform to help users improve their Y Combinator application answers.

3. User Responsibilities
You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.

4. Intellectual Property
The content, features, and functionality of ApplyYC are owned by Paatr.ai and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.

5. Limitation of Liability
Paatr.ai shall not be liable for any indirect, incidental, special, consequential or punitive damages resulting from your use of or inability to use the service.

6. Termination
We may terminate or suspend your account and bar access to the service immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever.

7. Changes to Terms
We reserve the right to modify or replace these Terms at any time. It is your responsibility to check the Terms periodically for changes.

8. Governing Law
These Terms shall be governed by and construed in accordance with the laws of Ontario, Canada, without regard to its conflict of law provisions.

9. Contact Us
If you have any questions about these Terms, please contact us at: admin@paatr.ai
''';
