import 'package:flutter/material.dart';
import 'package:sqlite_crude_app/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> allData = [];

  bool isLoading = true;

  void refreshData() async {
    final data = await SQLHelper.getAllData();

    setState(() {
      allData = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _descEditingController = TextEditingController();

  Future<void> addData() async {
    await SQLHelper.createData(
        _titleEditingController.text, _descEditingController.text);
    refreshData();
  }

  Future<void> updateData(int id) async {
    await SQLHelper.updateData(
        id, _titleEditingController.text, _descEditingController.text);
    refreshData();
  }

  void deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('User deleted'),
      ),
    );
    refreshData();
  }

  void showButtonSheet(int? id) async {
    if (id != null) {
      final existingData = allData.firstWhere((element) => element[id] == id);
      _titleEditingController.text = existingData['title'];
      _descEditingController.text = existingData['desc'];
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () => {}),
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allData.length,
              itemBuilder: (BuildContext context, index) {
                var data = allData[index];
                return ListTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(data['title']),
                  ),
                );
              }),
    );
  }
}
