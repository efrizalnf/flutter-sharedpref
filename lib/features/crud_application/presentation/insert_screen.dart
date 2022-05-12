import 'package:flutter/material.dart';

import '../helpers/data_prefs.dart';

class InsertScreen extends StatefulWidget {
  final int? index;
  final Map<String, dynamic>? value;

  const InsertScreen({
    required this.index,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  State<InsertScreen> createState() => _InsertScreenState();
}

class _InsertScreenState extends State<InsertScreen> {
  late int? index = widget.index;
  late Map<String, dynamic>? value = widget.value;

  final _nameC = TextEditingController();
  final _addressC = TextEditingController();
  final _phoneC = TextEditingController();

  // Function untuk validasi form insert
  bool isDataValid() {
    if (_nameC.text.isEmpty) {
      return false;
    }

    if (_addressC.text.isEmpty) {
      return false;
    }

    if (_phoneC.text.isEmpty) {
      return false;
    }

    return true;
  }

  // Function ini digunakan untuk proses update data
  void getData() {
    if (index != null && value != null) {
      setState(() {
        _nameC.text = value!['name'];
        _addressC.text = value!['address'];
        _phoneC.text = value!['phone'];
      });
    }
  }

  // Function ini berfungsi untuk proses create data
  void saveData() async {
    if (isDataValid()) {
      var user = {
        'name': _nameC.text,
        'address': _addressC.text,
        'phone': _phoneC.text,
      };

      var savedData = await DataPrefs.getData();

      // Jika index sama dengan null maka dilakukan proses create data,
      // Jika tidak maka yang dilakukan adalah proses update data
      if (index == null) {
        savedData.insert(0, user);
      } else {
        savedData[index] = user;
      }

      await DataPrefs.saveData(savedData);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Empty Field'),
          content: const Text('Please fill all field'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Function ini berfungsi untuk proses delete data
  void deleteData() async {
    var savedData = await DataPrefs.getData();
    savedData.removeAt(index);

    await DataPrefs.saveData(savedData);
    Navigator.pop(context);
  }

  // Widget Button Delete akan muncul jika proses yang terjadi adalah update
  // Jika proses yang terjadi adalah create, maka Button Delete tidak akan muncul
  Widget getDeleteButton() {
    if (index != null && value != null) {
      return TextButton(
        child: const Text(
          'DELETE',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          deleteData();
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _nameC.clear();
    _addressC.clear();
    _phoneC.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert'),
        actions: [
          getDeleteButton(),
          TextButton(
            onPressed: () {
              saveData();
            },
            child: const Text(
              'SAVE',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name'),
            TextField(
              controller: _nameC,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Address'),
            TextField(
              controller: _addressC,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Phone'),
            TextField(
              controller: _phoneC,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
