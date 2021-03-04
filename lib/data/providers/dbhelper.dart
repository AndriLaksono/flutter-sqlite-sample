import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/list_items.dart';
import '../models/shopping_list.dart';

class DBHelper {
  final int version = 1;
  Database db;

  // Factory constructor
  // instead of creating a new instance, the factory constructor only returns an instance of the class
  static final DBHelper _dbHelper = DBHelper._internal();
  DBHelper._internal();
  factory DBHelper() {
    return _dbHelper;
  }

  Future<Database> openDB() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'shopping.db'),
        onCreate: (database, version) {
          database.execute('CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');
          database.execute('CREATE TABLE items(id INTEGER PRIMARY KEY, list_id INTEGER, name TEXT,'
          + ' quantity TEXT, note TEXT' 
          + ', FOREIGN KEY(list_id) REFERENCES lists(id) )');
        }, 
        version: version
      );
    }
    return db;
  }

  Future testDB() async {
    try {
      Database _db = await openDB();
      await _db.execute('INSERT INTO lists VALUES(1, "Fruit", 2)');
      await _db.execute('INSERT INTO items VALUES(1, 1, "Apples", "2 Kilo", "Red Apple")');
      List<Map> lists = await _db.rawQuery('SELECT * FROM lists');
      List<Map> items = await _db.rawQuery('SELECT * FROM items');
      print(lists[0].toString());
      print(items[0].toString());
    } catch (e) {
      print(e);
    }
  }

  Future<int> insertList(ShoppingList list) async {
    try {
      int id = await db.insert(
        'lists', 
        list.toMap(), 
        conflictAlgorithm: ConflictAlgorithm.replace
      );
      return id;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future updateList(ShoppingList list) async {
    try {
      await db.update(
        'lists',
        list.toMap(),
        where: 'id = ?',
        whereArgs: [list.id]
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<int> deleteList(ShoppingList list) async {
    try {
      int result = await db.delete('items', where: 'list_id = ?', whereArgs: [list.id]);
      result = await db.delete('lists', where: 'id = ?', whereArgs: [list.id]);
      return result;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future<List<ShoppingList>> getLists() async {
    try {
      db = await openDB();
      final List<Map<String, dynamic>> maps = await db.query('lists', orderBy: 'priority ASC');
      return List.generate(maps.length, (i) {
        return ShoppingList(
          id: maps[i]['id'], 
          name: maps[i]['name'], 
          priority: maps[i]['priority']
        );
      });
    } catch (e) {
      print(e);
      return e;
    }
  }


  Future<int> insertItem(ListItem item) async {
    try {
      int id = await db.insert(
        'items', 
        item.toMap(), 
        conflictAlgorithm: ConflictAlgorithm.replace
      );
      return id;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future<List<ListItem>> getItems(int idList) async  {
    try {
      print(idList);
      final List<Map<String, dynamic>> maps = await db.query('items', where: 'list_id = ?', whereArgs: [idList]);
      return List.generate(maps.length, (i) {
        return ListItem(
          id: maps[i]['id'], 
          listId: maps[i]['list_id'], 
          name: maps[i]['name'], 
          quantity: maps[i]['quantity'], 
          note: maps[i]['note']
        );
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future updateItem(ListItem item) async {
    try {
      await db.update(
        'items',
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id]
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<int> deleteItem(ListItem item) async {
    try {
      int result = await db.delete('items', where: 'id = ?', whereArgs: [item.id]);
      return result;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

}