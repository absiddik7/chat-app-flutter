import 'package:flutter/material.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  Widget build(BuildContext context) {
    List user = [
      {
        "img":
            'https://pbs.twimg.com/profile_images/1564398871996174336/M-hffw5a_400x400.jpg',
        "name": 'Bill Gates',
      },
      {
        "img":
            'https://i.insider.com/635a60e9ea35650019e0694c?width=1136&format=jpeg',
        "name": 'Mark Zuckerberg',
      },
      {
        "img":
            'https://media.istockphoto.com/photos/headshot-portrait-of-smiling-male-employee-in-office-picture-id1309328823?k=20&m=1309328823&s=612x612&w=0&h=RqA2lYygvOxisNPp6UwFjz7bCw_rYITJMqFTMSrhpis=',
        "name": 'John Don',
      },
      {
        "img":
            'https://media-cldnry.s-nbcnews.com/image/upload/t_nbcnews-fp-1200-630,f_auto,q_auto:best/rockcms/2022-06/220610-donald-trump-2020-ac-432p-5730d1.jpg',
        "name": 'Donald Trump',
      },
      {
        "img": 'https://static.dw.com/image/63157554_605.jpg',
        "name": 'Vladimir Putin',
      },
      {
        "img":
            'https://pbs.twimg.com/profile_images/1564398871996174336/M-hffw5a_400x400.jpg',
        "name": 'Bill Gates',
      },
      {
        "img":
            'https://i.insider.com/635a60e9ea35650019e0694c?width=1136&format=jpeg',
        "name": 'Mark Zuckerberg',
      },
      {
        "img":
            'https://media.istockphoto.com/photos/headshot-portrait-of-smiling-male-employee-in-office-picture-id1309328823?k=20&m=1309328823&s=612x612&w=0&h=RqA2lYygvOxisNPp6UwFjz7bCw_rYITJMqFTMSrhpis=',
        "name": 'John Don',
      },
      {
        "img":
            'https://media-cldnry.s-nbcnews.com/image/upload/t_nbcnews-fp-1200-630,f_auto,q_auto:best/rockcms/2022-06/220610-donald-trump-2020-ac-432p-5730d1.jpg',
        "name": 'Donald Trump',
      },
      {
        "img": 'https://static.dw.com/image/63157554_605.jpg',
        "name": 'Vladimir Putin',
      },
      {
        "img":
            'https://pbs.twimg.com/profile_images/1564398871996174336/M-hffw5a_400x400.jpg',
        "name": 'Bill Gates',
      },
      {
        "img":
            'https://i.insider.com/635a60e9ea35650019e0694c?width=1136&format=jpeg',
        "name": 'Mark Zuckerberg',
      },
      {
        "img":
            'https://media.istockphoto.com/photos/headshot-portrait-of-smiling-male-employee-in-office-picture-id1309328823?k=20&m=1309328823&s=612x612&w=0&h=RqA2lYygvOxisNPp6UwFjz7bCw_rYITJMqFTMSrhpis=',
        "name": 'John Don',
      },
      {
        "img":
            'https://media-cldnry.s-nbcnews.com/image/upload/t_nbcnews-fp-1200-630,f_auto,q_auto:best/rockcms/2022-06/220610-donald-trump-2020-ac-432p-5730d1.jpg',
        "name": 'Donald Trump',
      },
      {
        "img": 'https://static.dw.com/image/63157554_605.jpg',
        "name": 'Vladimir Putin',
      },
      {
        "img":
            'https://pbs.twimg.com/profile_images/1564398871996174336/M-hffw5a_400x400.jpg',
        "name": 'Bill Gates',
      },
      {
        "img":
            'https://i.insider.com/635a60e9ea35650019e0694c?width=1136&format=jpeg',
        "name": 'Mark Zuckerberg',
      },
      {
        "img":
            'https://media.istockphoto.com/photos/headshot-portrait-of-smiling-male-employee-in-office-picture-id1309328823?k=20&m=1309328823&s=612x612&w=0&h=RqA2lYygvOxisNPp6UwFjz7bCw_rYITJMqFTMSrhpis=',
        "name": 'John Don',
      },
      {
        "img":
            'https://media-cldnry.s-nbcnews.com/image/upload/t_nbcnews-fp-1200-630,f_auto,q_auto:best/rockcms/2022-06/220610-donald-trump-2020-ac-432p-5730d1.jpg',
        "name": 'Donald Trump',
      },
      {
        "img": 'https://static.dw.com/image/63157554_605.jpg',
        "name": 'Vladimir Putin',
      },
      {
        "img":
            'https://pbs.twimg.com/profile_images/1564398871996174336/M-hffw5a_400x400.jpg',
        "name": 'Bill Gates',
      },
      {
        "img":
            'https://i.insider.com/635a60e9ea35650019e0694c?width=1136&format=jpeg',
        "name": 'Mark Zuckerberg',
      },
      {
        "img":
            'https://media.istockphoto.com/photos/headshot-portrait-of-smiling-male-employee-in-office-picture-id1309328823?k=20&m=1309328823&s=612x612&w=0&h=RqA2lYygvOxisNPp6UwFjz7bCw_rYITJMqFTMSrhpis=',
        "name": 'John Don',
      },
      {
        "img":
            'https://media-cldnry.s-nbcnews.com/image/upload/t_nbcnews-fp-1200-630,f_auto,q_auto:best/rockcms/2022-06/220610-donald-trump-2020-ac-432p-5730d1.jpg',
        "name": 'Donald Trump',
      },
      {
        "img": 'https://static.dw.com/image/63157554_605.jpg',
        "name": 'Vladimir Putin',
      },
      {
        "img":
            'https://pbs.twimg.com/profile_images/1564398871996174336/M-hffw5a_400x400.jpg',
        "name": 'Bill Gates',
      },
      {
        "img":
            'https://i.insider.com/635a60e9ea35650019e0694c?width=1136&format=jpeg',
        "name": 'Mark Zuckerberg',
      },
      {
        "img":
            'https://media.istockphoto.com/photos/headshot-portrait-of-smiling-male-employee-in-office-picture-id1309328823?k=20&m=1309328823&s=612x612&w=0&h=RqA2lYygvOxisNPp6UwFjz7bCw_rYITJMqFTMSrhpis=',
        "name": 'John Don',
      },
      {
        "img":
            'https://media-cldnry.s-nbcnews.com/image/upload/t_nbcnews-fp-1200-630,f_auto,q_auto:best/rockcms/2022-06/220610-donald-trump-2020-ac-432p-5730d1.jpg',
        "name": 'Donald Trump',
      },
      {
        "img": 'https://static.dw.com/image/63157554_605.jpg',
        "name": 'Vladimir Putin',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'People',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // search field
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(29),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
            ListView.builder(
              // padding: const EdgeInsets.symmetric(vertical: 25),
              shrinkWrap: true,
              itemCount: user.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(user[index]['img']),
                  ),
                  title: Text(user[index]['name']),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
