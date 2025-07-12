import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FileUploadService {
  Future<String?> uploadResume(String userId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.single.bytes != null) {
      final file = result.files.single;
      final ref = FirebaseStorage.instance.ref().child('resumes/$userId/${file.name}');
      await ref.putData(file.bytes!);
      String url = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'resumeUrl': url,
      });
      return url;
    }
    return null;
  }
}