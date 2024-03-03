import 'package:ftp_app/database/database_service.dart';
import 'package:sqflite/sqflite.dart';

class FtpDB {
  final tablename = 'users';
  final table2 = 'userinfo';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tablename(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "companyId" INTEGER NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL
    
  );""");
  }


  Future<void> createTableuserinfo(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $table2(
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "username" TEXT NOT NULL,
      "name" TEXT NOT NULL,
      "age" INTEGER NOT NULL,
      "mobile_no" INTEGER NOT NULL,
      "email" TEXT NOT NULL,
       FOREIGN KEY ("username") REFERENCES $tablename ("username")
    );""");
  }

  Future<int> insertuserinfo(
      String username,
      String name,
      int age,
      int mobile_no,
      String email) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $table2 (username,name,age,mobile_no,email) VALUES (?,?,?,?,?)''',
      [
        username,
        name,
        age,
        mobile_no,
        email
      ],
    );
  }

  Future<int> updateuserinfo(int id,
      String username,
      String name,
      int age,
      int mobile_no,
      String email) async {
    final database = await DatabaseService().database;
    return await database.update(
      table2,
      {
        'username': username,
        'name': name,
        'age': age,
        'mobile_no': mobile_no,
        'email': email
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> doesUsernameExist(String username) async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> result = await database.query(
      tablename,
      where: 'username = ?',
      whereArgs: [username],
    );
    return result
        .isNotEmpty; // Returns true if username exists, false otherwise
  }

  // Method to insert a new user if the username doesn't exist
  Future<int> insertUserIfNotExists(int companyId,String username, String password
      ) async {
    if (await doesUsernameExist(username)) {
      // Username already exists, return -1 or throw an error
      return -1;
    } else {
      // Username doesn't exist, proceed with insertion
      final database = await DatabaseService().database;
      return await database.insert(
        tablename,
        {'companyId': companyId,'username': username, 'password': password},
      );
    }
  }

  Future<Map<String, dynamic>?> getUser(int companyId,String username, String password,
      ) async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> result = await database.query(
      tablename,
      where: 'companyId = ? AND password = ? AND username = ? ',
      whereArgs: [companyId,username, password],
    );

    // If result is not empty, return the first user found
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null; // Return null if no user with the given username is found
    }
  }

  Future<List<Map<String, dynamic>>>? fetchDetail() async {
    final database = await DatabaseService().database;
    // Execute a query to fetch details from the 'details' table
    final result = await database.query(table2);
    return result.toList(); // Return the list of details
  }

    // Future<void> alterTable() async {
    //   final database = await DatabaseService().database;
    //   return await database.execute('ALTER TABLE users ADD COLUMN companyId INTEGER');
    //
    // }


  }
