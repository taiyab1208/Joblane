import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'job_detail_screen.dart';
import 'view_applicants_screen.dart';

class EmployerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('Employer Dashboard')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('postedBy', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final jobs = snapshot.data!.docs;
          if (jobs.isEmpty) return Center(child: Text('No jobs posted yet.'));
          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, i) {
              final job = jobs[i];
              return ListTile(
                title: Text(job['title']),
                subtitle: Text(job['company']),
                trailing: IconButton(
                  icon: Icon(Icons.people),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewApplicantsScreen(jobId: job.id, jobTitle: job['title']),
                      ),
                    );
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => JobDetailScreen(jobId: job.id)),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/post-job');
        },
      ),
    );
  }
}