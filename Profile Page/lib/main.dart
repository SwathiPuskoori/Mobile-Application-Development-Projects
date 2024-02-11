import 'data_model/userinfo.dart';
import 'package:flutter/material.dart';
import 'display.dart';

void main() {
  final user = UserInfo(
    image: 'assets/images/swathi2.png',
    name: 'Swathi Puskoori',
    position: 'Software Engineer',
    company: 'Tata Consultancy Services',
    contact: [
      Contact(
          logo: 'assets/images/phone.png',
          cont: '312-312-3123',
          title: 'Phone'),
      Contact(
          logo: 'assets/images/emailicon.png',
          cont: 'swathipuskoori@gmail.com',
          title: 'Email'),
      Contact(
          logo: 'assets/images/home.png',
          cont: '500 E 33rd St. Chicago Illinois 60616',
          title: 'Home'),
    ],
    education: [
      EducationInfo(
          logo: 'assets/images/griet.png', name: 'Under-Graduate', gpa: 9.8),
      EducationInfo(logo: 'assets/images/iit.png', name: 'Graduate', gpa: 3.8),
    ],
    projects: [
      ProjectInfo(
          title: 'Full-Stack',
          description: 'Creating TCS Web Pages',
          logo: 'assets/images/fullstack.png'),
      ProjectInfo(
          title: 'Networking',
          description: 'Automation Testing',
          logo: 'assets/images/network.png'),
      ProjectInfo(
          title: 'SDE',
          description: 'Software Development',
          logo: 'assets/images/sde.png'),
      ProjectInfo(
          title: 'Testing',
          description: 'Manual Testing',
          logo: 'assets/images/testing.png'),
    ],
  );
  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final UserInfo user;
  const MyApp({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProfilePage(user: user),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final UserInfo user;
  const ProfilePage({required this.user, super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 139, 228),
        centerTitle: true,
        title: const Text(
          'Profile Page',
        ),
      ),
      body: ListView(
        children: <Widget>[
          DetailsSection(user: user),
          ContactSection(user: user),
          EducationSection(user: user),
          ProjectsSection(user: user),
        ],
      ),
    );
  }
}
