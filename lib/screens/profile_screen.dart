import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'resume_upload_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? resumeUrl;
  String? email;
  String? userType;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        resumeUrl = doc['resumeUrl'];
        email = doc['email'];
        userType = doc['userType'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: email == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16),
              children: [
                ListTile(title: Text('Email'), subtitle: Text(email!)),
                ListTile(title: Text('User Type'), subtitle: Text(userType!)),
                if (resumeUrl != null)
                  ListTile(
                    title: Text('Resume'),
                    subtitle: Text('View/Download'),
                    onTap: () async {
                      if (await canLaunch(resumeUrl!)) {
                        await launch(resumeUrl!);
                      }
                    },
                  ),
                ElevatedButton(
                  child: Text('Upload/Replace Resume'),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ResumeUploadScreen()),
                    );
                    _loadProfile();
                  },
                ),
              ],
            ),
    );
  }
}