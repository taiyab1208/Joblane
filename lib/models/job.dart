import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final String postedBy;
  final DateTime postedAt;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.postedBy,
    required this.postedAt,
  });

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    return Job(
      id: documentId,
      title: data['title'] ?? '',
      company: data['company'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      postedBy: data['postedBy'] ?? '',
      postedAt: (data['postedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'postedBy': postedBy,
      'postedAt': postedAt,
    };
  }
}