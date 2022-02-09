import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:students_app/screens/login.dart';
import 'package:students_app/controller/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  String title, name, faculty, major, address, photo,
  url = 'http://192.168.0.5:8000/';
  int id;
  File _image;
  bool _status = true, loading = true;
  final _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _facultyController = TextEditingController();
  var _majorController = TextEditingController();
  var _addressController = TextEditingController();

  Widget buildNameField() {
    return Flexible(
      child: TextFormField(
        controller: _nameController..text = name,
        enabled: _status,
        decoration: const InputDecoration(
          hintText: 'Masukkan Nama Anda',
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Nama Dibutuhkan.';
          }
          return null;
        },
        onSaved: (String value) {
          title = value;
        },
      ),
    );
  }

  Widget buildFacultyField() {
    return Flexible(
      child: TextFormField(
        controller: _facultyController..text = faculty,
        enabled: _status,
        decoration: const InputDecoration(
          hintText: 'Masukkan Fakultas',
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Fakultas Dibutuhkan.';
          }
          return null;
        },
        onSaved: (String value) {
          title = value;
        },
      ),
    );
  }

  Widget buildMajorField() {
    return Flexible(
      child: TextFormField(
        controller: _majorController..text = major,
        enabled: _status,
        decoration: const InputDecoration(
          hintText: 'Masukkan Jurusan',
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Jurusan Dibutuhkan.';
          }
          return null;
        },
        onSaved: (String value) {
          title = value;
        },
      ),
    );
  }

  Widget buildAddressField() {
    return Flexible(
      child: TextFormField(
        controller: _addressController..text = address,
        enabled: _status,
        decoration: const InputDecoration(
          hintText: 'Masukkan Alamat',
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Alamat Dibutuhkan.';
          }
          return null;
        },
        onSaved: (String value) {
          title = value;
        },
      ),
    );
  }

  @override
  void initState(){
    _loadUserData();
    super.initState();
  }
  _loadUserData() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if(user != null) {
      setState(() {
        id = user['id'];
        name = user['name'];
        faculty = user['faculty'];
        major = user['major'];
        address = user['address'];
        photo = user['photo'];
      });
    }
  }

  Future updateUser() async{
    final response =
    await http.post(Uri.parse(url+"api/v1/user_update/"+id.toString()+'?_method=PUT'),
        body: {
          "name" : _nameController.text,
          "faculty" : _facultyController.text,
          "major" : _majorController.text,
          "address" : _addressController.text,
        }
    );

    var body = json.decode(response.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Student App'),
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                logout();
              },
            )
          ],
        ),
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    new Container(
                      height: 200.0,
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: new Stack(fit: StackFit.loose, children: <Widget>[
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    child: photo != null?
                                    Container(
                                        width: 140.0,
                                        height: 140.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            image: new NetworkImage(
                                                url+'image/'+photo),
                                            fit: BoxFit.cover,
                                          ),
                                        )):
                                    _image != null?
                                    Container(
                                        width: 140.0,
                                        height: 140.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            image: new FileImage(_image),
                                            fit: BoxFit.cover,
                                          ),
                                        )):
                                    Container(
                                        width: 140.0,
                                        height: 140.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            image: new ExactAssetImage(
                                                'assets/images/as.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 90.0, right: 100.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        radius: 25.0,
                                        child: new IconButton(
                                          icon: new Icon(Icons.camera_alt),
                                          color: Colors.white,
                                          onPressed: getGalleryImage,
                                        ),
                                      )
                                    ],
                                  )),
                            ]),
                          )
                        ],
                      ),
                    ),
                    new Container(
                      color: Color(0xffFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Informasi Mahasiswa',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Container(),
                                      ],
                                    )
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Nama',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    buildNameField(),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Fakultas',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    buildFacultyField(),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Jurusan',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    buildMajorField(),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Alamat',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    buildAddressField(),
                                  ],
                                )),
                            _status ? _getActionButtons() : new Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Simpan"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      _scaffoldKey.currentState.showSnackBar(
                          new SnackBar(duration: new Duration(seconds: 4), content:
                          new Row(
                            children: <Widget>[
                              new CircularProgressIndicator(),
                              new Text("Menyimpan...")
                            ],
                          ),
                          ));
                      updateUser()
                          .whenComplete(() =>
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                                (Route<dynamic> route) => false,
                          )
                      );
                      _uploadImage(_image);
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  Future getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<Map<String, dynamic>> _uploadImage(File image) async {

    final mimeTypeData =
    lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(
        url+"api/v1/user_update/"+id.toString()+"?_method=PUT"));

    final file = await http.MultipartFile.fromPath(
        'photo', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.files.add(file);
    // imageUploadRequest.fields['name'] = nameCntrl;
    // imageUploadRequest.fields['faculty'] = facultyCntrl;
    // imageUploadRequest.fields['major'] = majorCntrl;
    // imageUploadRequest.fields['address'] = addressCntrl;

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void logout() async{
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Login()));
    }
  }

}

