import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/file_upload_service.dart';

class ResumeUploadScreen extends StatefulWidget {
  @override
  _ResumeUploadScreenState createState() => _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends State<ResumeUploadScreen> {
  bool uploading = false;
  String? resumeUrl;
  String? error;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('Upload Resume')),
      body: Center(
        child: uploading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.upload_file),
                    label: Text('Upload Resume'),
                    onPressed: () async {
                      setState(() {
                        uploading = true;
                        error = null;
                      });
                      try {
                        String? url = await FileUploadService().uploadResume(user!.uid);
                        setState(() {
                          resumeUrl = url;
                        });
                        if (url != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Resume uploaded!')),
                          );
                        }
                      } catch (e) {
                        setState(() {
                          error = e.toString();
                        });
                      }
                      setState(() {
                        uploading = false;
                      });
                    },
                  ),
                  if (resumeUrl != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Resume uploaded!'),
                    ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(error!, style: TextStyle(color: Colors.red)),
                    ),
                ],
              ),
      ),
    );
  }
}