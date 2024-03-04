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
    try {
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
    } catch (e) {
      print('Error inserting user info: $e');
      return -1;
    }
  }


  Future<int> updateuserinfo(
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
      where: 'username = ?',
      whereArgs: [username],
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


  Future<int> insertUserIfNotExists(int companyId,String username, String password
      ) async {
    if (await doesUsernameExist(username)) {
      return -1;
    } else {
      final database = await DatabaseService().database;
      return await database.insert(
        tablename,
        {'companyId': companyId,'username': username, 'password': password},
      );
    }
  }

  Future<bool> doesUsernameExistintable2(String username) async {
    final database= await DatabaseService().database;
    final List<Map<String, dynamic>> result= await database.query( table2,
        where: 'username = ?',
        whereArgs: [username],
    );
        return result.isNotEmpty;
  }



   // Returns true if username exists, false otherwise

  Future<Map<String, dynamic>?> getUser(int companyId,String username, String password,
      ) async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> result = await database.query(
      tablename,
      where: 'companyId = ? AND username = ? AND password = ? ',
      whereArgs: [companyId,username, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>>? fetchDetail() async {
    final database = await DatabaseService().database;
    final result = await database.query(table2);
    return result.toList(); // Return the list of details
  }




  }
