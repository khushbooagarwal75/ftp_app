import 'package:flutter/material.dart';

import 'package:ftp_app/database/database_service.dart';
import 'package:ftp_app/database/ftp_db.dart';
import 'package:ftp_app/try.dart';
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
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController companyid = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password_tc = TextEditingController();

  bool visible = false;
  bool tapped=false;
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
        backgroundColor: Colors.white ,
        body: Stack(
          children: [
            ClipPath(
              child: Container(
                color:Colors.cyan.shade600,
                // Color.fromRGBO(200,250,156,1),
              ),
              clipper: custom(),
            ),
            Positioned(
              width: 410,
              top:  MediaQuery.of(context).size.height/12,
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      color:Color.fromRGBO(130, 110, 224, 1.0),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: FlutterLogo(
                      style: FlutterLogoStyle.markOnly,
                    ),
                  ),
                  SizedBox(height: 100,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text("LOGIN",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                ),),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: companyid,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87,width: 4),
                                      borderRadius: BorderRadius.circular(20)// Change the border color here
                                  ),
                                  hintText: "Company Id",
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)// Change the border color here as well
                                  ),),
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
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87,width: 4),
                                      borderRadius: BorderRadius.circular(20)// Change the border color here
                                  ),
                                  hintText: "Username in email format",
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)// Change the border color here as well
                                  ),),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter  Username';
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
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87,width: 4),
                                      borderRadius: BorderRadius.circular(20)// Change the border color here
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)// Change the border color here as well
                                  ),),
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
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: Colors.cyan.shade600,
                                      textStyle: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,

                                      )
                                    // Set the text color to white
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        tapped=true;
                                      });
                                      final user = username.text;
                                      final password = password_tc.text;
                                      final id = int.parse(companyid.text);
                                      var uservalid = await FtpDB().getUser(id, user, password);

                                      // Check if user is not null to determine if credentials are valid
                                      if (uservalid != null) {
                                        Get.to(() => Bar(), arguments:{
                                          'username':user,
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Invalid Credentials'),
                                          ),
                                        );
                                      }
                                    } else {
                                      // User doesn't exist, handle accordingly
                                      print('User does not exist');
                                    }
                                  },
                                  child: tapped? CircularProgressIndicator():Text("Login"),

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}
class custom extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path= new Path();
    path.lineTo(0.0, size.height/2.5);
    path.lineTo(size.width-100, 0.0);


    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}