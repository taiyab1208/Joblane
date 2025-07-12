import 'package:cloud_firestore/cloud_firestore.dart';

class Application {
  final String id;
  final String jobId;
  final String applicantId;
  final String applicantEmail;
  final String resumeUrl;
  final DateTime appliedAt;

  Application({
    required this.id,
    required this.jobId,
    required this.applicantId,
    required this.applicantEmail,
    required this.resumeUrl,
    required this.appliedAt,
  });

  factory Application.fromMap(Map<String, dynamic> data, String documentId) {
    return Application(
      id: documentId,
      jobId: data['jobId'],
      applicantId: data['applicantId'],
      applicantEmail: data['applicantEmail'],
      resumeUrl: data['resumeUrl'],
      appliedAt: (data['appliedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'applicantId': applicantId,
      'applicantEmail': applicantEmail,
      'resumeUrl': resumeUrl,
      'appliedAt': appliedAt,
    };
  }
}