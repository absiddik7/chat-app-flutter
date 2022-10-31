import 'package:flutter/material.dart';
import 'package:messenger/screens/chatsScreen.dart';
import 'package:messenger/screens/peopleScreen.dart';
import 'package:messenger/screens/settingScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  // const HomeScreen(
  //     {super.key,
  //     required this.authToken,
  //     required this.userId,
  //     required this.userName});
  // final String? authToken;
  // final int? userId;
  // final String? userName;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottonBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

//botom naivation bar pages
  final pages = [
    const ChatsScreen(),
    const PeopleScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   //title: const Text('FIRE'),
      //   backgroundColor: Colors.deepPurple[300],
      // ),

      body: pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            //canvasColor: Colors.green[100],
            // primaryColor: Colo
            ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottonBar,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_sharp), label: 'Chats'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'People'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}
