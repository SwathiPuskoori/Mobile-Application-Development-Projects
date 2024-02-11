import 'package:flutter/material.dart';
import 'data_model/userinfo.dart';

class ContactSection extends StatelessWidget {
  final UserInfo user;
  const ContactSection({required this.user, super.key});
  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.blue[50],
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Contact :',
            style: TextStyle(
              fontFamily: 'Shantel',
              fontSize: height * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Wrap(
            spacing: 1,
            runSpacing: 3,
            children: user.contact
                .map((contact) => ContactWidget(
                      contact: contact,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class ContactWidget extends StatelessWidget {
  final Contact contact;

  const ContactWidget({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          GestureDetector(
            child: Image.asset(
              contact.logo,
              width: width * 0.1,
              height: height * 0.1,
            ),
            onTap: () => _showBottomSheet(context, contact.cont),
          ),
          Text(
            contact.title,
            style: TextStyle(
              fontFamily: 'Shantel',
              fontSize: height * 0.02,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsSection extends StatelessWidget {
  final UserInfo user;
  const DetailsSection({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    double calculateFontSize(String text) {
      double factor = textScaleFactor * height;

      if (text.length > 20) {
        return factor * .015;
      } else if (text.length > 10) {
        return factor * .03;
      } else if (text.length > 5) {
        return factor * .06;
      }

      return textScaleFactor * 20;
    }

    return Container(
      color: Colors.pink[50],
      height: height * 0.2,
      width: width,
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: width * 0.3,
            height: height * 0.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(user.image),
                fit: BoxFit.fitHeight,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
          ),
          //const SizedBox(
          //  width: 0.2,
          //),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                  fontSize: calculateFontSize(user.name),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Shantel',
                ),
              ),
              //SizedBox(height: height * 0.05),
              Text(
                user.position,
                style: TextStyle(
                  fontSize: calculateFontSize(user.position),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Shantel',
                ),
              ),
              Text(
                user.company,
                style: TextStyle(
                  fontSize: calculateFontSize(user.company),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Shantel',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EducationSection extends StatelessWidget {
  final UserInfo user;
  const EducationSection({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height * 0.304,
      padding: const EdgeInsets.all(2.0),
      color: Colors.green[50],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Education:',
            style: TextStyle(
              fontFamily: 'Shantel',
              fontSize: height * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children:
                user.education.map((edu) => DisplayEdu(edu: edu)).toList(),
          ),
        ],
      ),
    );
  }
}

class DisplayEdu extends StatelessWidget {
  final EducationInfo edu;

  const DisplayEdu({super.key, required this.edu});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height * 0.1,
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //const Spacer(),
          Image.asset(
            edu.logo,
            height: height * 0.15,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            edu.name,
            style: TextStyle(
                fontSize: height * 0.025,
                fontFamily: 'Shantel',
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            'CGPA: ${edu.gpa}',
            style: TextStyle(
                fontSize: height * 0.03,
                fontFamily: 'Shantel',
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class ProjectsSection extends StatelessWidget {
  final UserInfo user;
  const ProjectsSection({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: const Color.fromARGB(255, 239, 219, 255),
      padding: const EdgeInsets.all(1.0),
      height: height * .6,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Projects :',
            style: TextStyle(
              fontFamily: 'Shantel',
              fontSize: height * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Wrap(
            spacing: 1,
            runSpacing: 1,
            children: user.projects
                .map((project) => FavoriteWidget(
                      project: project,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class FavoriteWidget extends StatelessWidget {
  final ProjectInfo project;

  const FavoriteWidget({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          GestureDetector(
            child: Image.asset(
              project.logo,
              width: width * 0.2,
              height: height * 0.2,
            ),
            onTap: () => _showBottomSheet(context, project.description),
          ),
          const SizedBox(height: 1),
          Text(
            project.title,
            style: TextStyle(
              fontFamily: 'Shantel',
              fontSize: height * 0.02,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 1),
        ],
      ),
    );
  }
}

void _showBottomSheet(BuildContext context, String message) {
  showModalBottomSheet(
    context: context,
    builder: (ctx) => Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Shantel',
          fontSize: 20,
        ),
      ),
    ),
  );
}
