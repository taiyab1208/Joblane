import 'package:flutter/material.dart';
import '../services/application_service.dart';
import '../models/application.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewApplicantsScreen extends StatelessWidget {
  final String jobId;
  final String jobTitle;
  ViewApplicantsScreen({required this.jobId, required this.jobTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Applicants for $jobTitle')),
      body: StreamBuilder<List<Application>>(
        stream: ApplicationService().getApplicationsForJob(jobId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final applicants = snapshot.data!;
          if (applicants.isEmpty) return Center(child: Text('No applicants yet.'));
          return ListView.builder(
            itemCount: applicants.length,
            itemBuilder: (context, i) {
              final app = applicants[i];
              return ListTile(
                title: Text(app.applicantEmail),
                subtitle: Text('Applied on  ${app.appliedAt.toLocal()}'),
                trailing: IconButton(
                  icon: Icon(Icons.download),
                  onPressed: () async {
                    if (await canLaunch(app.resumeUrl)) {
                      await launch(app.resumeUrl);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}