import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'request.dart'; 
import 'authentication_screen.dart';
import 'dart:convert';

class ClientScreen extends StatefulWidget {
  final String username;

  ClientScreen({required this.username});

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  int? searchRequestId;
  TextEditingController _deviceTypeController = TextEditingController();
  TextEditingController _issueDescriptionController = TextEditingController();
  List<Request> requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _submitRequest() async {
  Random random = Random();
  int requestId = random.nextInt(100);

    Request newRequest = Request(
      id: requestId,
      deviceType: _deviceTypeController.text,
      issueDescription: _issueDescriptionController.text,
      status: 'В ожидании',
    );

    setState(() {
      requests.add(newRequest);
    });

    await _saveRequests();

    _deviceTypeController.clear();
    _issueDescriptionController.clear();
  }

  Future<void> _saveRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> requestsJsonList = requests.map((request) => jsonEncode(request.toJson())).toList();
    prefs.setStringList('requests', requestsJsonList);
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

  void _updateRequestStatus(int requestId, String newStatus) {
    setState(() {
      Request updatedRequest = requests.firstWhere((request) => request.id == requestId);
      updatedRequest.status = newStatus;
    });
    _saveRequests();
  }

  Future<void> _showSubmitRequestDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Оформление заявки'),
          content: Column(
            children: [
              TextField(
                controller: _deviceTypeController,
                decoration: InputDecoration(labelText: 'Тип устройства'),
              ),
              TextField(
                controller: _issueDescriptionController,
                decoration: InputDecoration(labelText: 'Описание поломки'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                _submitRequest();
                Navigator.of(context).pop();
              },
              child: Text('Оставить заявку'),
            ),
          ],
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Добро пожаловать!',
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
          SizedBox(height: 20.0),
          Text('Ваши заявки:'),
          Expanded(
            child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                if (searchRequestId != null && requests[index].id != searchRequestId) {
                  return Container(); 
                }
                return ListTile(
                  title: Text('Заявка #${requests[index].id}'),
                  subtitle: Text(
                    'Тип устройства: ${requests[index].deviceType}\n'
                    'Описание: ${requests[index].issueDescription}\n'
                    'Статус: ${requests[index].status}',
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                _showSubmitRequestDialog();
              },
              child: Text('Оформить заявку'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ООО "ТЕХНОСЕРВИС"',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 30.0),
                Text(
                  'Качественно и быстро отремонтируем любую технику!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
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
  title: Text('Информация о пользователе'),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserInfoScreen()),
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

class UserInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация о пользователе'),
      ),
      body: Padding(
        padding: EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoItem(label: 'Имя и Фамилия', value: 'Алина Шарыпова'),
            UserInfoItem(label: 'Возраст', value: '19 лет'),
            UserInfoItem(label: 'Группа', value: 'ИСП-222'),
            UserInfoItem(label: 'Преподаватель', value: 'Рыжов Дмитрий Владимирович'),
          ],
        ),
      ),
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final String label;
  final String value;

  UserInfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}