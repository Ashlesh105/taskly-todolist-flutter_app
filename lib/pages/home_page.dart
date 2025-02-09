import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly_app/models/task.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;
  String? _newTaskValue;
  Box? _box;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    print("Input Value: $_newTaskValue");
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
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (_snapshot.hasData) {
            _box = _snapshot.data;
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
        builder: (BuildContext _context) {
          return AlertDialog(
            title: Text("Add New Task!"),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: "Enter Task"),
              onChanged: (_value) {
                setState(() {
                  _newTaskValue = _value;
                });
              },
              onSubmitted: (_value) {
                if (_newTaskValue != null) {
                  Task _newTask = Task(
                      content: _newTaskValue!,
                      timeStamp: DateTime.now(),
                      done: false);
                  _box?.add(_newTask.toMap());
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
    List _tasks = _box!.values.toList();
    return ListView.builder(
        itemBuilder: (BuildContext _context, int _index) {
          var task = Task.fromMap(_tasks[_index]);
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
              _box?.putAt(_index, task.toMap());
            },
            onLongPress: (){
              setState(() {
                _box?.deleteAt(_index);
              });
            },
          );
        },
        itemCount: _tasks.length);
  }
}
