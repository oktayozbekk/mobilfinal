import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late Database _database;
  List<Map<String, dynamic>> _todoItems = [];
  List<Map<String, dynamic>> _filteredTodoItems = [];
  final _todoController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _openDatabase().then((database) {
      _database = database;
      _loadTodoItems();
    });
  }

  Future<Database> _openDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'todo.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE todo_items(
            id INTEGER PRIMARY KEY,
            title TEXT,
            is_done INTEGER
          )
        ''');
      },
    );
  }

  Future<void> _loadTodoItems() async {
    final List<Map<String, dynamic>> todoItems =
        await _database.query('todo_items');
    setState(() {
      _todoItems = todoItems;
      _filterTodoItems();
    });
  }

  Future<void> _addTodoItem(String title) async {
    await _database.insert(
      'todo_items',
      {'title': title, 'is_done': 0},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    _loadTodoItems();
  }

  Future<void> _updateTodoItem(int id, String title) async {
    await _database.update(
      'todo_items',
      {'title': title},
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadTodoItems();
  }

  Future<void> _toggleTodoItem(int id, bool isDone) async {
    await _database.update(
      'todo_items',
      {'is_done': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadTodoItems();
  }

  Future<void> _deleteTodoItem(int id) async {
    await _database.delete(
      'todo_items',
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadTodoItems();
  }

  void _filterTodoItems() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredTodoItems = _todoItems.reversed.toList();
      });
    } else {
      setState(() {
        _filteredTodoItems = _todoItems
            .where((item) => item['title']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();
      });
    }
  }

  void _showEditDialog(int id, String currentTitle) {
    showDialog(
      context: this.context,
      builder: (BuildContext dialogContext) {
        String newTitle = currentTitle;
        return AlertDialog(
          title: Text('Düzenle'),
          content: TextField(
            controller: TextEditingController(text: currentTitle),
            onChanged: (value) {
              newTitle = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Vazgeç'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Kaydet'),
              onPressed: () {
                _updateTodoItem(id, newTitle);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: this.context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Sil'),
          content: Text('Emin misiniz? Göreviniz Silinecek..'),
          actions: [
            TextButton(
              child: Text('Vazgeç'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Sil'),
              onPressed: () {
                _deleteTodoItem(id);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text('Yapılacaklar')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(7.0),
            margin: const EdgeInsets.all(7.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _filterTodoItems();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Ara',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(42))),
                hintText: 'Ara',
              ),
            ),
          ),
          RichText(
            text: TextSpan(
                text: 'Yapacaklarım',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.purple)),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: _filteredTodoItems.length,
              itemBuilder: (BuildContext context, int index) {
                final todoItem = _filteredTodoItems[index];
                return ListTile(
                  title: Text(
                    todoItem['title'],
                  ),
                
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                   
                       GestureDetector(
                        child: Icon(
                          Icons.edit,
                        ),
                        onTap: () {
                         _showEditDialog(todoItem['id'], todoItem['title']);
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.delete, color: Color(0xffc41810)
                        ),
                        onLongPress: () {
                          _showDeleteConfirmationDialog(todoItem['id']);
                        },
                      ),
                     
                    ],
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  margin:
                      const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                      hintText: 'Ekle',
                      border: InputBorder.none,
                    ),
                  ),
                )),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      _addTodoItem(_todoController.text);
                      _todoController.text = "";
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        minimumSize: const Size(60, 60),
                        elevation: 10),
                    child: const Text(
                      "+",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}