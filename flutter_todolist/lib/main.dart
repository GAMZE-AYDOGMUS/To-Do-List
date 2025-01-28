import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoListScreen(),
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask(String task) {
    setState(() {
      _tasks.add({'task': task, 'completed': false});
    });
    _controller.clear();
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
  }

  void _editTask(int index) {
    final TextEditingController editController =
        TextEditingController(text: _tasks[index]['task']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Görevi Düzenle"),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              labelText: "Yeni Görev Adı",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapat
              },
              child: Text("İPTAL"),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  setState(() {
                    _tasks[index]['task'] = editController.text;
                  });
                }
                Navigator.of(context).pop(); // Dialog'u kapat
              },
              child: Text("KAYDET"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("To-Do List"),
          actions: [
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                setState(() {
                  _tasks.clear();
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Yeni Görev',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          _addTask(_controller.text);
                        }
                      },
                      child: Text("EKLE"),
                    ),
                  ],
                ),
              ),
              Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          task['completed'] ? Colors.green : Colors.blue,
                      child: Icon(
                        task['completed'] ? Icons.check : Icons.pending,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      task['task'],
                      style: TextStyle(
                        decoration: task['completed']
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _editTask(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeTask(index),
                        ),
                      ],
                    ),
                    onTap: () => _toggleTaskCompletion(index),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
