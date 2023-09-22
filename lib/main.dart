import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class CompletedTask {
  String title;
  DateTime creationDate;
  DateTime completionDate;

  CompletedTask(this.title, this.creationDate, this.completionDate);
}

class Task {
  String title;
  bool isCompleted;
  DateTime creationDate;
  DateTime? editDate;

  Task(this.title, this.isCompleted, this.creationDate, {this.editDate});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = [];
  List<CompletedTask> completedTasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List DIO'),
      ),
      body: ListView.builder(
        itemCount: tasks.length + completedTasks.length,
        itemBuilder: (context, index) {
          if (index < tasks.length) {
            // Exibir tarefas pendentes
            return ListTile(
              title: Text(tasks[index].title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Data de Inclusão: ${DateFormat.yMd().add_Hms().format(tasks[index].creationDate)}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              leading: Checkbox(
                value: tasks[index].isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    tasks[index].isCompleted = value!;
                    if (value!) {
                      // Mover tarefa concluída para a lista de tarefas concluídas
                      completedTasks.add(CompletedTask(
                          tasks[index].title,
                          tasks[index].creationDate,
                          DateTime.now()));
                      tasks.removeAt(index);
                    }
                  });
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editTask(context, index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        tasks.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            );
          } else {
            // Exibir tarefas concluídas
            final completedIndex = index - tasks.length;
            return ListTile(
              title: Text(completedTasks[completedIndex].title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Data de Conclusão: ${DateFormat.yMd().add_Hms().format(completedTasks[completedIndex].completionDate)}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTask(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTask(BuildContext context) {
    String newTaskTitle = "";
    DateTime currentDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nova Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  newTaskTitle = value;
                },
                decoration: InputDecoration(labelText: 'Tarefa'),
              ),
              SizedBox(height: 8),
              Text(
                'Data de Inclusão: ${DateFormat.yMd().add_Hms().format(currentDate)}',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Adicionar'),
              onPressed: () {
                if (newTaskTitle.isNotEmpty) {
                  setState(() {
                    tasks.add(Task(newTaskTitle, false, currentDate));
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editTask(BuildContext context, int index) {
    String updatedTitle = tasks[index].title;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  updatedTitle = value;
                },
                controller: TextEditingController(text: tasks[index].title),
                decoration: InputDecoration(labelText: 'Tarefa'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                if (updatedTitle.isNotEmpty) {
                  setState(() {
                    tasks[index].title = updatedTitle;
                    tasks[index].editDate = DateTime.now();
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
