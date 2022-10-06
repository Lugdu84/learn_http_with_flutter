class User {
  final int id;
  final String name;
  final String email;
  final String city;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.city});
  User.fromJSON(Map<String, dynamic> json)
      : id = json["id"],
        name = json["username"],
        email = json["email"],
        city = json["address"]["city"];
}
