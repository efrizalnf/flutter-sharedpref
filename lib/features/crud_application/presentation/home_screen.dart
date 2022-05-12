import 'package:flutter/material.dart';

import './insert_screen.dart';
import '../helpers/data_prefs.dart';

class HomeSceeen extends StatefulWidget {
  const HomeSceeen({Key? key}) : super(key: key);

  @override
  State<HomeSceeen> createState() => _HomeSceeenState();
}

class _HomeSceeenState extends State<HomeSceeen> {
  var savedData = [];

  void getSavedData() async {
    var data = await DataPrefs.getData();
    setState(() {
      savedData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InsertScreen(
                    index: null,
                    value: null,
                  ),
                ),
              ).then(
                (_) => getSavedData(),
              );
            },
            child: const Text(
              'ADD',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: savedData.isEmpty
            ? const Center(
                child: Text('No Data'),
              )
            : ListView.builder(
                itemCount: savedData.length,
                // ListTile Untuk Membuat List Data layout
                itemBuilder: (ctx, i) => ListTile(
                  leading: CircleAvatar(
                    child: Text('${i + 1}'),
                  ),
                  title: Text(savedData[i]['name']!),
                  subtitle: Text(savedData[i]['address']! +
                      ' / ' +
                      savedData[i]['phone']!),
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InsertScreen(
                          index: i,
                          value: savedData[i],
                        ),
                      ),
                    ).then(
                      (_) => getSavedData(),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
