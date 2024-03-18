import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_auth_app/Models/note_model.dart';
import 'package:sqflite_auth_app/Models/users_model.dart';

class DatabaseHelper {
  final databaseName = "notes.db";
  String noteTable =
      "CREATE TABLE notes (noteId INTEGER PRIMARY KEY AUTOINCREMENT, noteTitle TEXT NOT NULL, noteContent TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";

  String users =
      "create table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT)";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
      await db.execute(noteTable);
    });
  }

  //--------------------------------Authentication Method-------------------------------------
  
  //login
  Future<bool> login(Users user) async {
    final database = await initDB();

    // check forgot password 
    var result = await database.rawQuery(
      "select * from users where usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Sign up
  Future<int> signup(Users user) async {
    final database = await initDB();

    return database.insert('users', user.toMap());
  }

  //Get users
  Future<List<Users>> getUsers() async {
    final database = await initDB();
    List<Map<String, Object?>> result = await database.query('users');
    return result.map((index) => Users.fromMap(index)).toList();
  }

  //Delete User
  Future<int> deleteUser(int id) async {
    final database = await initDB();
    return database.delete('users', where: 'usrId = ?', whereArgs: [id]);
  }

  //-----------------------------------Search Method---------------------------------------------

  Future<List<NoteModel>> searchNotes(String keyword) async {
    final database = await initDB();
    List<Map<String, Object?>> searchResult = await database.rawQuery(
      "select * from notes where noteTitle LIKE ?", ["%$keyword%"]);
    return searchResult.map((index) => NoteModel.fromMap(index)).toList();
  }

  //---------------------------------------CRUD Methods for Notes--------------------------------------------

  //Create Note
  Future<int> addNote(NoteModel note) async {
    final database = await initDB();
    return database.insert('notes', note.toMap());
  }

  //Get notes
  Future<List<NoteModel>> getNotes() async {
    final database = await initDB();
    List<Map<String, Object?>> result = await database.query('notes');
    return result.map((index) => NoteModel.fromMap(index)).toList();
  }

  //Update Notes
  Future<int> updateNote(title, content, noteId) async {
    final database = await initDB();
    return database.rawUpdate(
        'update notes set noteTitle = ?, noteContent = ? where noteId = ?',
        [title, content, noteId]);
  }

  //Delete Notes
  Future<int> deleteNote(int id) async {
    final database = await initDB();
    return database.delete('notes', where: 'noteId = ?', whereArgs: [id]);
  }
}
