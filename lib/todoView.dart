import 'package:flutter/material.dart';
import 'package:todo_task/todo.dart';

class TodoView extends StatefulWidget {
  final Todo todo;

  TodoView({required this.todo});

  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    descriptionController = TextEditingController(text: widget.todo.description);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, widget.todo..title = titleController.text..description = descriptionController.text);
                  },
                  child: const Text("Save"),
                ),
                Switch(
                  value: widget.todo.status,
                  onChanged: (value) {
                    setState(() {
                      widget.todo.status = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
