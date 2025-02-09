import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly_app/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight;
  String? _newTaskValue;
  Box? _box;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    // print("Input Value: $_newTaskValue");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        toolbarHeight: _deviceHeight * 0.15,
        title: Text(
          "Taskly!",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      body: _taskView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _taskView() {
    return FutureBuilder(
        future: Hive.openBox('tasks'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _box = snapshot.data;
            return _taskList();
          } else {
            return Center(
                child: CircularProgressIndicator(
                    color: Colors.red, backgroundColor: Colors.black));
          }
        });
  }

  void _displayTaskPopUp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add New Task!"),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: "Enter Task"),
              onChanged: (value) {
                setState(() {
                  _newTaskValue = value;
                });
              },
              onSubmitted: (value) {
                if (_newTaskValue != null) {
                  Task newTask = Task(
                      content: _newTaskValue!,
                      timeStamp: DateTime.now(),
                      done: false);
                  _box?.add(newTask.toMap());
                  Navigator.of(context).pop(); /**/
                }
              },
            ),
          );
        });
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
        onPressed: _displayTaskPopUp,
        backgroundColor: Colors.red,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ));
  }

  Widget _taskList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var task = Task.fromMap(tasks[index]);
          return ListTile(
            title: Text(
              task.content,
              style: task.done
                  ? TextStyle(decoration: TextDecoration.lineThrough,color: Colors.red)
                  : null,
            ),
            subtitle: Text(task.timeStamp.toString()),
            trailing: task.done
                ? Icon(Icons.check_box,color: Colors.red,)
                : Icon(Icons.check_box_outline_blank),
            onTap: (){
              setState(() {
                task.done = !task.done;
              });
              _box?.putAt(index, task.toMap());
            },
            onLongPress: (){
              setState(() {
                _box?.deleteAt(index);
              });
            },
          );
        },
        itemCount: tasks.length);
  }
}
