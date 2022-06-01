import 'package:flutter/material.dart';
import '../db/helper.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _todoItems = [];
  @override
  void initState() {
    _todoItems = HiveHelper.getTodo();
    super.initState();
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showfelids(context, null),
      ),
      appBar: AppBar(
        
        elevation: 20,
        centerTitle: true,
        title: const Text("Todo"),
      ),
      body: SafeArea(
        child: _todoItems.isEmpty
            ? const Center(
                child: Text(
                  "No Todo items,add some Todos..",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Color.fromARGB(255, 115, 115, 115),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (BuildContext context, int index) {
                  final _Todos = _todoItems[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        _Todos["title"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      subtitle: Text(
                        _Todos["description"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      //delete.
                      trailing: IconButton(
                        color: Colors.red,
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          HiveHelper.deleteTodo(_Todos['key']);
                          setState(() {
                            _todoItems = HiveHelper.getTodo();
                          });
                        },
                      ),
                      onTap: () {
                        _showfelids(context, _Todos['key']);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showfelids(BuildContext context, int? key) {
    if (key != null) {
      final _currentIndex =
          _todoItems.firstWhere((items) => items['key'] == key);
      _titleController.text = _currentIndex["title"];
      _descriptionController.text = _currentIndex["description"];
    }
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              key == null
                  ? const Text(
                      'Add Todo',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    )
                  : const Text(
                      'Update Todo',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
              const SizedBox(
                width: 100,
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          actions: [
            _customFields(1, _titleController, 'Title'),
            const SizedBox(height: 10),
            _customFields(5, _descriptionController, 'Description'),
            Center(
              child: ElevatedButton(
                child: key == null ? const Text('Add') : const Text('Update'),
                onPressed: () {
                  if (key == null) {
                    HiveHelper.addTodo(
                      {
                        "title": _titleController.text,
                        "description": _descriptionController.text,
                      },
                    );
                  } else {
                    HiveHelper.updateTodo(
                      key,
                      {
                        "title": _titleController.text,
                        "description": _descriptionController.text,
                      },
                    );
                  }

                  _titleController.clear();
                  _descriptionController.clear();
                  setState(() {
                    _todoItems = HiveHelper.getTodo();
                    Navigator.pop(context);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  TextFormField _customFields(
    int lines,
    TextEditingController _controller,
    String hintText,
  ) {
    return TextFormField(
      maxLines: lines,
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
        label: Text(hintText),
      ),
    );
  }
}
