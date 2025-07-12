import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/job.dart';
import '../services/job_service.dart';

class PostJobScreen extends StatefulWidget {
  @override
  _PostJobScreenState createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '', company = '', location = '', description = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post a Job')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Job Title'),
                onChanged: (val) => title = val,
                validator: (val) => val!.isEmpty ? 'Enter job title' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Company'),
                onChanged: (val) => company = val,
                validator: (val) => val!.isEmpty ? 'Enter company' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                onChanged: (val) => location = val,
                validator: (val) => val!.isEmpty ? 'Enter location' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 5,
                onChanged: (val) => description = val,
                validator: (val) => val!.isEmpty ? 'Enter description' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true);
                    final user = FirebaseAuth.instance.currentUser;
                    final job = Job(
                      id: '',
                      title: title,
                      company: company,
                      location: location,
                      description: description,
                      postedBy: user!.uid,
                      postedAt: DateTime.now(),
                    );
                    await JobService().postJob(job);
                    setState(() => loading = false);
                    Navigator.pop(context);
                  }
                },
                child: loading ? CircularProgressIndicator() : Text('Post Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}