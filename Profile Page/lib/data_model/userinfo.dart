class UserInfo {
  final String image;
  final String name;
  final String position;
  final String company;
  final List<Contact> contact;

  final List<EducationInfo> education;
  final List<ProjectInfo> projects;

  UserInfo(
      {required this.image,
      required this.name,
      required this.position,
      required this.company,
      required this.education,
      required this.projects,
      required this.contact});
}

class EducationInfo {
  final String logo;
  final String name;
  final double gpa;

  EducationInfo({
    required this.logo,
    required this.name,
    required this.gpa,
  });
}

class ProjectInfo {
  final String title;
  final String description;
  final String logo;

  ProjectInfo(
      {required this.title, required this.description, required this.logo});
}

class Contact {
  final String logo;
  final String cont;
  final String title;

  Contact({required this.logo, required this.cont, required this.title});
}
