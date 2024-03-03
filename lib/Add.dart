import 'package:flutter/material.dart';
import 'package:ftp_app/database/database_service.dart';
import 'package:ftp_app/database/ftp_db.dart';
import 'package:sqflite/sqflite.dart';

class Showinformation extends StatefulWidget {
  const Showinformation({super.key});

  @override
  State<Showinformation> createState() => _ShowinformationState();
}

class _ShowinformationState extends State<Showinformation> {
  late Database? database;
  // late String username;
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController mobile_no = TextEditingController();
  TextEditingController email = TextEditingController();

  late DatabaseService databaseService;
  // late final String partNameValue;
  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService();
    _initializeDatabase();
    fetchData();
  }
  Future<void> _initializeDatabase() async {
    database = await databaseService.database;
    setState(() {});
  }

  Future<void> fetchData() async {
    final ftpDB = FtpDB();
    final List<Map<String, dynamic>>? details = await ftpDB.fetchDetail();
    if (details != null) {
      print(details);

      // .text = details[0]["partname"] as String;
    // username= details[0]["username"] as String;
    name.text = details[0]["name"] as String;
    age.text = details[0]["age"].toString();
    mobile_no.text = details[0]["mobile_no"].toString();
    email.text = details[0]["email"] as String;
      // print(partNameValue);
    } else {
      name.text = "name is empty" as String;
      age.text = "age is empty" as String;
      mobile_no.text = "mobile_no is empty" as String;
      email.text = "email is empty" as String;
      // Handle the case where details are null (e.g., error occurred)
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
              onPressed: () {}, color: Colors.white, icon: Icon(Icons.edit)),
        ],
        title: Text("Profile Information"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Company Id:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("123",style: TextStyle(
                        fontSize: 18.0,

                      ),),
                      SizedBox(width: 13.0),
                      Text(
                        'Username:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Username",style: TextStyle(
                        fontSize: 18.0,

                      ),),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Name:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      hintText: "name",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                        ),
                      ),
                    ),

                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Age:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: age,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "age",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'mobile_no:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: mobile_no,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: "mobile_no",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                        ),
                      ),
                    ),

                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Email:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "email",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                        ),
                      ),
                    ),

                  ),
                  SizedBox(height: 4.0),
                  ElevatedButton(
                    onPressed: () async {
                      // if (_formKey.currentState!.validate()) {
                      //   String _partName = partName.text.toString();
                      //   int _partNumber = int.tryParse(partNumber.text) ?? 0;
                      //   int _quantity = int.tryParse(quantity.text) ?? 0;
                      //   String _fromLocation = fromLocation.text;
                      //   String _toLocation = toLocation.text;
                      //   String _transferDate = transferDate.text;
                      //   print(_partName);
                      //   print(_partNumber);
                      //   print(_quantity);
                      //   print(_fromLocation);
                      //   print(_toLocation);
                      //   print(_transferDate);
                      //
                      //   await FtpDB().updateDetails(1, _partNumber, _quantity,
                      //       _fromLocation, _toLocation, _transferDate);
                      // }
                      if(name.text.isNotEmpty && age.text.isNotEmpty && mobile_no.text.isNotEmpty && email.text.isNotEmpty){
                        int ag=int.parse(age.text);
                        int mob=int.parse(mobile_no.text);
                       await FtpDB().insertuserinfo("khushi75@gmail.com", name.text, ag, mob , email.text);

                      }
                      else{
                        print("fill all details");
                      }
                    },
                    child: Text("UPDATE DETAILS"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Future<void> fetchData() async {
//   final ftpDB = FtpDB();
//   final List<Map<String, dynamic>>? details = await ftpDB.fetchDetail();
//   if (details != null) {
//     print(details);
//     username= details[0]["username"] as String;
//     name.text = details[0]["name"].toString();
//     age.text = details[0]["age"].toString();
//     mobile_no.text = details[0]["mobile_no"] as String;
//     email.text = details[0]["email"] as String;
//
//     // print(partNameValue);
//   } else {
//     // Handle the case where details are null (e.g., error occurred)
//   }
// }
