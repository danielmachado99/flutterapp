import 'package:flutter/material.dart';

class WorkerProfileScreen extends StatelessWidget {
  final Map<String, String> worker;

  WorkerProfileScreen({required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(worker['name']!),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              worker['name']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Job: ${worker['job']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle booking functionality
              },
              child: Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}
