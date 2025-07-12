import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/application.dart';

class ApplicationService {
  final CollectionReference applications = FirebaseFirestore.instance.collection('applications');

  Future<void> applyToJob(Application application) async {
    await applications.add(application.toMap());
  }

  Stream<List<Application>> getApplicationsForJob(String jobId) {
    return applications.where('jobId', isEqualTo: jobId).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Application.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList(),
    );
  }

  Stream<List<Application>> getApplicationsForEmployer(String employerId) {
    return applications.where('employerId', isEqualTo: employerId).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Application.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList(),
    );
  }
}