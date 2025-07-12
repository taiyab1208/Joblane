import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job.dart';

class JobService {
  final CollectionReference jobs = FirebaseFirestore.instance.collection('jobs');

  Future<void> postJob(Job job) async {
    await jobs.add(job.toMap());
  }

  Stream<List<Job>> getJobs({String? keyword, String? location}) {
    Query query = jobs.orderBy('postedAt', descending: true);
    if (keyword != null && keyword.isNotEmpty) {
      query = query.where('title', isGreaterThanOrEqualTo: keyword).where('title', isLessThanOrEqualTo: keyword + '\uf8ff');
    }
    if (location != null && location.isNotEmpty) {
      query = query.where('location', isEqualTo: location);
    }
    return query.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Job.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList()
    );
  }

  Future<Job> getJobById(String id) async {
    DocumentSnapshot doc = await jobs.doc(id).get();
    return Job.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }
}