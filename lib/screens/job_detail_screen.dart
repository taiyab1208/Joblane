import 'package:flutter/material.dart';
import '../services/job_service.dart';
import '../models/job.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/application_service.dart';
import '../models/application.dart';

class JobDetailScreen extends StatelessWidget {
  final String jobId;
  JobDetailScreen({required this.jobId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Job>(
      future: JobService().getJobById(jobId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Scaffold(body: Center(child: CircularProgressIndicator()));
        final job = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: Text(job.title)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(job.company, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(job.location, style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text(job.description),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) return;
                    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                    final resumeUrl = userDoc['resumeUrl'] ?? '';
                    if (resumeUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please upload your resume first.')));
                      return;
                    }
                    final application = Application(
                      id: '',
                      jobId: job.id,
                      applicantId: user.uid,
                      applicantEmail: user.email ?? '',
                      resumeUrl: resumeUrl,
                      appliedAt: DateTime.now(),
                    );
                    await ApplicationService().applyToJob(application);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Application submitted!')));
                  },
                  child: Text('Apply Now'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}