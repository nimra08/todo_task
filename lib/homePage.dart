import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_task/todo.dart';
import 'package:todo_task/todoView.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences prefs;
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    setupTodo();
  }

  Future<void> setupTodo() async {
    prefs = await SharedPreferences.getInstance();
    String? stringTodo = prefs.getString('todo');
    if (stringTodo != null) {
      List todoList = jsonDecode(stringTodo);
      for (var todo in todoList) {
        setState(() {
          todos.add(Todo.fromJson(todo));
        });
      }
    }
  }

  void saveTodo() {
    List items = todos.map((e) => e.toJson()).toList();
    prefs.setString('todo', jsonEncode(items));
  }

  Color appColor = const Color.fromRGBO(58, 66, 86, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Todo"),
        backgroundColor: appColor,
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(64, 75, 96, .9),
              ),
              child: ListTile(
                title: Text(
                  todos[index].title.isNotEmpty ? todos[index].title : 'Untitled',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  todos[index].description.isNotEmpty ? todos[index].description : 'No description',
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () async {
                        Todo? updatedTodo = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoView(todo: todos[index]),
                          ),
                        );
                        if (updatedTodo != null) {
                          setState(() {
                            todos[index] = updatedTodo;
                          });
                          saveTodo();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () => delete(todos[index]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.black12,
        onPressed: addTodo,
      ),
    );
  }

  Future<void> addTodo() async {
    int id = Random().nextInt(30);
    Todo newTodo = Todo(id: id, title: '', description: '', status: false);
    Todo? returnTodo = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoView(todo: newTodo)),
    );
    if (returnTodo != null) {
      setState(() {
        todos.add(returnTodo);
      });
      saveTodo();
    }
  }

  void delete(Todo todo) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Alert"),
        content: const Text("Are you sure to delete?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                todos.remove(todo);
              });
              Navigator.pop(ctx);
              saveTodo();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}
