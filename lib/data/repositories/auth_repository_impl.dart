import 'dart:math';

import 'package:testcrudbloc/core/constants/app_constants.dart';
import 'package:testcrudbloc/data/datasources/local/database_helper.dart';
import 'package:testcrudbloc/domain/entities/user.dart';
import 'package:testcrudbloc/domain/repositories/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  final DatabaseHelper _databaseHelper;

  AuthRepositoryImpl(this._databaseHelper);

  @override
  Future<User> registerUser(String email, String password) async {
    final db = await _databaseHelper.database;

    // Verificar si el usuario ya existe
    final existingUsers = await db.query(
      AppConstants.usersTable,
      where: '${AppConstants.columnUserEmail} = ?',
      whereArgs: [email],
    );

    if (existingUsers.isNotEmpty) {
      throw Exception('El usuario ya existe');
    }

    // Crear un nuevo usuario
    final token = generateToken();
    final user = User(
      email: email,
      password: password,
      token: token,
      isLogged: true,
    );

    // Insertar en la base de datos
    final id = await db.insert(
      AppConstants.usersTable,
      user.toMap(),
    );

    return user.copyWith(id: id);
  }

  @override
  Future<User?> login(String email, String password) async {
    final db = await _databaseHelper.database;

    // Buscar el usuario
    final results = await db.query(
      AppConstants.usersTable,
      where: '${AppConstants.columnUserEmail} = ? AND ${AppConstants.columnUserPassword} = ?',
      whereArgs: [email, password],
    );

    if (results.isEmpty) {
      return null;
    }

    // Generar un nuevo token
    final token = generateToken();
    
    // Actualizar el token y el estado de login
    final user = User.fromMap(results.first);
    final updatedUser = user.copyWith(
      token: token,
      isLogged: true,
    );

    // Actualizar en la base de datos
    await db.update(
      AppConstants.usersTable,
      updatedUser.toMap(),
      where: '${AppConstants.columnUserId} = ?',
      whereArgs: [updatedUser.id],
    );

    return updatedUser;
  }

  @override
  Future<void> logout() async {
    final db = await _databaseHelper.database;

    // Buscar usuarios loggeados
    final results = await db.query(
      AppConstants.usersTable,
      where: '${AppConstants.columnUserIsLogged} = ?',
      whereArgs: [1],
    );

    if (results.isEmpty) {
      return;
    }

    // Para cada usuario loggeado, limpiar el token y cambiar el estado
    for (final result in results) {
      final user = User.fromMap(result);
      final updatedUser = user.copyWith(
        token: '',
        isLogged: false,
      );

      await db.update(
        AppConstants.usersTable,
        updatedUser.toMap(),
        where: '${AppConstants.columnUserId} = ?',
        whereArgs: [updatedUser.id],
      );
    }
  }

  @override
  Future<User?> checkAuthStatus() async {
    final db = await _databaseHelper.database;

    // Buscar usuarios loggeados
    final results = await db.query(
      AppConstants.usersTable,
      where: '${AppConstants.columnUserIsLogged} = ?',
      whereArgs: [1],
    );

    if (results.isEmpty) {
      return null;
    }

    // Devolver el primer usuario loggeado
    return User.fromMap(results.first);
  }

  @override
  String generateToken() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    
    return List.generate(24, (index) => chars[random.nextInt(chars.length)]).join();
  }
}