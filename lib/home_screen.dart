import 'package:flutter/material.dart';
import 'worker_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> workers = [
    {'name': 'John Doe', 'job': 'Plumber'},
    {'name': 'Jane Smith', 'job': 'Electrician'},
    {'name': 'Sam Wilson', 'job': 'Carpenter'},
  ];

  List<Map<String, String>> filteredWorkers = [];

  @override
  void initState() {
    super.initState();
    filteredWorkers = workers;
  }

  void _filterWorkers(String query) {
    final results = workers.where((worker) {
      final workerName = worker['name']!.toLowerCase();
      final input = query.toLowerCase();
      return workerName.contains(input);
    }).toList();

    setState(() {
      filteredWorkers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hire Workers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterWorkers,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredWorkers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredWorkers[index]['name']!),
                  subtitle: Text(filteredWorkers[index]['job']!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WorkerProfileScreen(worker: filteredWorkers[index]),
                      ),
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
