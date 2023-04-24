import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
          primarySwatch: Colors.grey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          checkboxTheme: CheckboxThemeData(
            shape: CircleBorder(),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage() : super();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> todoList = [];
  bool isTodoFieldEmpty = true;
  TextEditingController todoController = TextEditingController();

  void addTodo() {
    if (todoController.text.isNotEmpty) {
      setState(() {
        todoList.add(todoController.text);
        todoController.clear();
      });
    }
  }

  void editTodoItem(int index) {
    TextEditingController editController =
        TextEditingController(text: todoList[index]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Edit Todo Item",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: editController,
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              todoList[index] = editController.text;
                            });
                            Navigator.pop(context);
                          },
                          child: Text("Save"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void deleteTodoItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text(
          "Todo List",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Open user account menu
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: todoController,
                    decoration: InputDecoration(
                      hintText: "Add a new todo item...",
                    ),
                    onChanged: (value) {
                      setState(() {
                        isTodoFieldEmpty = value.isEmpty;
                      });
                    },
                    onSubmitted: (value) {
                      addTodo();
                    },
                  ),
                ),
                if (!isTodoFieldEmpty)
                  IconButton(
                    icon: Icon(Icons.done),
                    onPressed: isTodoFieldEmpty
                        ? null
                        : () {
                            addTodo();
                          },
                  ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Dismissible(
                      key: Key(todoList[index]),
                      child: CheckboxListTile(
                        title: Text(
                          todoList[index],
                          style: TextStyle(
                            decoration: todoList[index].startsWith('DONE')
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        value: todoList[index].startsWith('DONE'),
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue == true &&
                                !todoList[index].startsWith('DONE')) {
                              todoList[index] = 'DONE: ' + todoList[index];
                            } else if (newValue == false &&
                                todoList[index].startsWith('DONE')) {
                              todoList[index] =
                                  todoList[index].replaceAll('DONE: ', '');
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        secondary: IconButton(
                          icon: todoList[index].startsWith('DONE')
                              ? Icon(Icons.delete, color: Colors.red)
                              : Icon(Icons.edit),
                          onPressed: () {
                            if (todoList[index].startsWith('DONE')) {
                              deleteTodoItem(index);
                            } else {
                              editTodoItem(index);
                            }
                          },
                        ),
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      onDismissed: (direction) {
                        deleteTodoItem(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
