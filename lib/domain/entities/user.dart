// Modelo de Usuario para la aplicación
class User {
  final int? id;
  final String email;
  final String password;
  final String? token;
  final bool isLogged;

  User({
    this.id,
    required this.email,
    required this.password,
    this.token,
    this.isLogged = false,
  });

  // Convertir User a Map para almacenar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'token': token,
      'is_logged': isLogged ? 1 : 0,
    };
  }

  // Factory constructor para crear un User desde un Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      token: map['token'],
      isLogged: map['is_logged'] == 1,
    );
  }

  // Crear una copia de User con nuevos valores
  User copyWith({
    int? id,
    String? email,
    String? password,
    String? token,
    bool? isLogged,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
      isLogged: isLogged ?? this.isLogged,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, token: $token, isLogged: $isLogged)';
  }
}