import 'package:flutter/material.dart';
import '../services/job_service.dart';
import '../models/job.dart';
import 'job_detail_screen.dart';

class JobListScreen extends StatefulWidget {
  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  String keyword = '';
  String location = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Find Jobs')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Keyword'),
                    onChanged: (val) => setState(() => keyword = val),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Location'),
                    onChanged: (val) => setState(() => location = val),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => setState(() {}),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Job>>(
              stream: JobService().getJobs(keyword: keyword, location: location),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final jobs = snapshot.data!;
                if (jobs.isEmpty) return Center(child: Text('No jobs found.'));
                return ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, i) {
                    final job = jobs[i];
                    return ListTile(
                      title: Text(job.title),
                      subtitle: Text('${job.company} • ${job.location}'),
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
          ),
        ],
      ),
    );
  }
}