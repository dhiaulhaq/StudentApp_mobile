import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:students_app/controller/api.dart';
import 'package:students_app/screens/home.dart';
import 'package:students_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget{
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>{
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _secureText = true;
  String name, faculty, major, username, password;

  showHide(){
    setState(() {
      _secureText = !_secureText;
    });
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      backgroundColor: Colors.blue,
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(top: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Formulir Pendaftaran",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue
                                ),
                              ),
                              SizedBox(height: 18),
                              TextFormField(
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Nama",
                                  ),
                                  validator: (nameValue){
                                    if(nameValue.isEmpty){
                                      return 'Masukkan nama anda';
                                    }
                                    name = nameValue;
                                    return null;
                                  }
                              ),
                              SizedBox(height: 12),
                              TextFormField(
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Fakultas",
                                  ),
                                  validator: (facultyValue){
                                    if(facultyValue.isEmpty){
                                      return 'Masukkan fakultas anda';
                                    }
                                    faculty = facultyValue;
                                    return null;
                                  }
                              ),
                              SizedBox(height: 12),
                              TextFormField(
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Jurusan",
                                  ),
                                  validator: (majorValue){
                                    if(majorValue.isEmpty){
                                      return 'Masukkan jurusan anda';
                                    }
                                    major = majorValue;
                                    return null;
                                  }
                              ),
                              SizedBox(height: 12),
                              TextFormField(
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Username",
                                  ),
                                  validator: (usernameValue){
                                    if(usernameValue.isEmpty){
                                      return 'Please enter your username';
                                    }
                                    username = usernameValue;
                                    return null;
                                  }
                              ),
                              SizedBox(height: 12),
                              TextFormField(
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.text,
                                  obscureText: _secureText,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    suffixIcon: IconButton(
                                      onPressed: showHide,
                                      icon: Icon(_secureText
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                  ),
                                  validator: (passwordValue){
                                    if(passwordValue.isEmpty){
                                      return 'Please enter your password';
                                    }
                                    password = passwordValue;
                                    return null;
                                  }
                              ),
                              SizedBox(height: 12),
                              FlatButton(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                  child: Text(
                                    _isLoading? 'Memproses..' : 'Daftar',
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                color: Colors.blue,
                                disabledColor: Colors.grey,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(20.0)),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _register();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sudah punya akun? ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Login()));
                        },
                        child: Text(
                          'Masuk',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _register() async{
    setState(() {
      _isLoading = true;
    });
    var data = {
      'name' : name,
      'faculty' : faculty,
      'major' : major,
      'username' : username,
      'password' : password
    };

    var res = await Network().authData(data, '/register');
    var body = json.decode(res.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }else{
      if(body['message']['name'] != null){
        _showMsg(body['message']['name'][0].toString());
      }
      else if(body['message']['faculty'] != null){
        _showMsg(body['message']['faculty'][0].toString());
      }
      else if(body['message']['major'] != null){
        _showMsg(body['message']['major'][0].toString());
      }
      else if(body['message']['username'] != null){
        _showMsg(body['message']['username'][0].toString());
      }
      else if(body['message']['password'] != null){
        _showMsg(body['message']['password'][0].toString());
      }
    }

    setState(() {
      _isLoading = false;
    });
  }
}