import 'dart:convert';
import 'dart:io' as io;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'package:user_list/models/address_model.dart';
import 'package:user_list/models/user_model.dart';

class DbHelper {
  Database? _database;
  Uuid uuid = const Uuid();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'users.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        id TEXT PRIMARY KEY, 
        firstName TEXT, 
        lastName TEXT, 
        birthDate TEXT,
        addresses TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE addresses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        street TEXT,
        city TEXT,
        state TEXT,
        postalCode TEXT
      )
    ''');
  }

  Future<User> insertUser(User user) async {
    var dbClient = await database;
    user.id = uuid.v4();
    await dbClient.insert('user', {
      'id': user.id,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'birthDate': user.birthDate.toIso8601String(),
      'addresses': jsonEncode(user.addresses.map((address) => address.toMap()).toList()),
    });
    return user;
  }

  Future<Address> insertAddress(Address address, String userId) async {
    var dbClient = await database;
    await dbClient.insert('addresses', {
      'userId': userId,
      'street': address.street,
      'city': address.city,
      'state': address.state,
      'postalCode': address.postalCode,
    });
    return address;
  }

  Future<List<User>> getUserList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult = await dbClient.query('user');
    List<User> users = queryResult.map((result) => User.fromMap(result)).toList();
    return users;
  }

  Future<List<Address>> getAddressList(String userId) async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult = await dbClient.query(
      'addresses',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    List<Address> addresses = queryResult.map((result) => Address.fromMap(result)).toList();
    return addresses;
  }

  Future<User> getUserDetails(String userId) async {
    var dbClient = await database;
    final List<Map<String, dynamic>> userResult = await dbClient.query('user', where: 'id = ?', whereArgs: [userId]);
    if (userResult.isEmpty) {
      throw Exception('User not found');
    }
    final Map<String, dynamic> userMap = userResult.first;
    final List<Map<String, dynamic>> addressResult = await dbClient.query(
      'addresses',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    final List<Address> addresses = addressResult.map((addressMap) => Address.fromMap(addressMap)).toList();
    final User user = User.fromMap(userMap);
    user.addresses = addresses;
    return user;
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'user',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}
