import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'first_page.dart';
import 'second_page.dart';
import 'third_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userEmail = '';
  String _userId = '';
  String _role = '';
  List<Map> _listdata = [];
  String _userName = '';
  String _userJob = '';

  int pageIndex = 0;

  List<Widget> pages = [const FirstPage(), const SecondPage(), ThirdPage(getNama: '',)];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('userEmail') ?? '';
      _userId = prefs.getString('userId') ?? '';
      _role = prefs.getString('role') ?? '';
    });

    await _getdata();
    setState(() {
      if(_listdata.isNotEmpty){
        _userName = _listdata[0]['nama_pegawai'] ?? '';
        _userJob = _listdata[0]['jobdesk'] ?? '';
        pages = [const FirstPage(), const SecondPage(), ThirdPage(getNama: _userName,)];
      }
    });
  }

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          'https://hafiz.barudakkoding.com/fotocopy-api/public/pegawai/${_userId.toString()}'));
      if (response.statusCode == 200) {
        // print(response.body);
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          setState(() {
            _listdata = [data];
          });
        } else {
          print('Unexpected data format');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.amberAccent,
        ),
        backgroundColor: Colors.brown,
        title: Text(
          "Fotocopy App",
          style: TextStyle(
            color: Colors.amberAccent,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Card(
              child: ListTile(
                trailing: Icon(Icons.person),
                title: Text(_userName.isNotEmpty && _userName != null
                    ? '$_userName'
                    : "000"),
                leading: Text(_userJob.isNotEmpty && _userJob != null
                    ? '${_userJob}'
                    : "000"),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Logout'),
                trailing: const Icon(Icons.logout),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            )
          ],
        ),
      ),
      body: pages[pageIndex],
      bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.brown,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 0;
                  });
                },
                icon: pageIndex == 0
                    ? const Icon(
                        Icons.home_filled,
                        color: Colors.white,
                        size: 35,
                      )
                    : const Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
              ),
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 2;
                  });
                },
                icon: pageIndex == 2
                    ? const Icon(
                        Icons.widgets_rounded,
                        color: Colors.white,
                        size: 35,
                      )
                    : const Icon(
                        Icons.widgets_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
              ),
              if (_role == 'admin')
                IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                  icon: pageIndex == 1
                      ? const Icon(
                          Icons.data_saver_off,
                          color: Colors.white,
                          size: 35,
                        )
                      : const Icon(
                          Icons.data_saver_on,
                          color: Colors.white,
                          size: 35,
                        ),
                ),
            ],
          )),
    );
  }
}
