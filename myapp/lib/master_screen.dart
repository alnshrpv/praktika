import 'package:flutter/material.dart';
import 'request.dart'; 
import 'authentication_screen.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MasterScreen extends StatefulWidget {
  final String username;

  MasterScreen({required this.username});

  @override
  _MasterScreenState createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int? searchRequestId;
  List<Request> requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _saveRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> requestsJsonList = requests.map((request) => jsonEncode(request.toJson())).toList();
    prefs.setStringList('requests', requestsJsonList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
        'Домашняя страница',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color.fromARGB(255, 147, 101, 161),
    ),
      body: Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
         SizedBox(height: 2.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Color.fromARGB(255, 152, 128, 156), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: 'Поиск по номеру заявки',
                  border: InputBorder.none,
                      ),
                  onChanged: (value) {
                    setState(() {
                      searchRequestId = int.tryParse(value);
                    });
                  },
                ),
              ),
            ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                if (searchRequestId != null && requests[index].id != searchRequestId) {
                  return Container();
                }
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Заявка №${requests[index].id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Тип устройства: ${requests[index].deviceType}'),
                          Text('Описание: ${requests[index].issueDescription}'),
                          SizedBox(height: 2.0),
                          DropdownButton<String>(
                            value: requests[index].status,
                            onChanged: (String? newStatus) {
                              setState(() {
                                requests[index].status = newStatus!;
                              });
                              _saveRequests();
                            },
                            items: <String>['В ожидании', 'В работе', 'Выполнена']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
           DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 147, 101, 161),
            ),
              child: Text(
                'Рабочий экран',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Список мастеров'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MasterListScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Выход из аккаунта'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthenticationScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? requestsJsonList = prefs.getStringList('requests');

    if (requestsJsonList != null) {
      List<Request> loadedRequests = requestsJsonList.map((json) => Request.fromJson(jsonDecode(json))).toList();
      setState(() {
        requests = loadedRequests;
      });
    }
  }
}

class MasterListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список мастеров'),
      ),
      body: Column(
        children: [
          MasterCard(name: 'Иванов Иван', experience: '5 лет'),
          MasterCard(name: 'Олегов Олег', experience: '6 лет'),
        ],
      ),
    );
  }
}

class MasterCard extends StatelessWidget {
  final String name;
  final String experience;

  MasterCard({required this.name, required this.experience});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5.0),
      child: ListTile(
        title: Text(name),
        subtitle: Text('Стаж работы: $experience'),
      ),
    );
  }
}