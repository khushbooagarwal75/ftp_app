import 'package:flutter/material.dart';
import 'package:ftp_app/Add.dart';
import 'package:ftp_app/database/database_service.dart';
import 'package:ftp_app/database/ftp_db.dart';
import 'package:get/get.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController companyid = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password_tc = TextEditingController();

  bool visible = false;
  late DatabaseService databaseService;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseService = DatabaseService();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final database = await databaseService.database; //
    await FtpDB().createTable(database);
    await FtpDB().createTableuserinfo(database);

    int result1 = await FtpDB()
        .insertUserIfNotExists(123,'khushi75@gmail.com', 'Khushi75TRY');
    if (result1 == -1) {
      // Username already exists, handle the error
    } else {
      // User inserted successfully
    }
    int result2 = await FtpDB()
        .insertUserIfNotExists(123,'Deepak@gmail.com', 'Deepak123');
    if (result2 == -1) {
    } else {}
    int result3 =
    await FtpDB().insertUserIfNotExists(123,'Mrigraj@gmail.com', 'Mrigraj123');
    if (result3 == -1) {
    } else {}

    await FtpDB().createTableuserinfo(database);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finished Part Transfer"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: companyid,
                      decoration: InputDecoration(
                          hintText: "Company Id",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                              ))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter  CompanyId';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: username,
                      decoration: InputDecoration(
                          hintText: "Username",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                              ))),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter  Usrname';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: password_tc,
                      decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(visible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                visible = !visible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                              ))),
                      obscureText: visible,
                      obscuringCharacter: "*",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter  password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final user = username.text;
                              final password = password_tc.text;
                              final id = int.parse(companyid.text);
                              final userExists =
                              await FtpDB().doesUsernameExist(user);
                              if (userExists) {
                                // User exists, handle login logic here
                                var login = await FtpDB().getUser(
                                    id, user, password);
                                print(login);
                                // if(login != null){
                                Get.to(() => Showinformation(), arguments:{
                                  'username':user,
                                });
                              } else {
                                // User doesn't exist, handle accordingly
                                print('User does not exist');
                              }
                            }},
                          child: Text("Log In"),

                    ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}