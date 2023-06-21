import 'dart:async';
import 'package:provider/provider.dart';
import 'package:user_list/data/db_helper.dart';
import 'package:user_list/models/address_model.dart';
import 'package:user_list/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:user_list/screens/user_details_screen.dart';
import 'package:user_list/screens/user_form_screen.dart';

class UserBloc extends ChangeNotifier {
  final _dbHelper = DbHelper();
  final _userListController = StreamController<List<User>>.broadcast();
  final _userController = StreamController<User>.broadcast();
  final _addressListController = StreamController<List<Address>>.broadcast();

  Stream<List<User>> get userListStream => _userListController.stream;
  Stream<User> get userStream => _userController.stream;
  Stream<List<Address>> get addressListStream => _addressListController.stream;

  void fetchUserList() async {
    List<User> userList = await _dbHelper.getUserList();
    _userListController.sink.add(userList);
  }

  void fetchUserDetails(String userId) async {
    User userDetails = await _dbHelper.getUserDetails(userId);
    _userController.sink.add(userDetails);
  }

  void saveUser(User user) async {
    await _dbHelper.insertUser(user);
    fetchUserList();
  }

  void updateUser(User user) async {
    await _dbHelper.updateUser(user);
    fetchUserList();
  }

  void addAddress(Address address, String userId) async {
    await _dbHelper.insertAddress(address, userId);
    fetchUserDetails(userId);
    List<Address> addressList = await _dbHelper.getAddressList(userId);
    if (!_addressListController.isClosed) {
      _addressListController.sink.add(addressList);
    }
  }

  @override
  void dispose() {
    _userListController.close();
    _userController.close();
    _addressListController.close();
    super.dispose();
  }

  void getAddressList(String userId) async {
    List<Address> addressList = await _dbHelper.getAddressList(userId);
    _addressListController.sink.add(addressList);
  }

  void navigateToUserDetailsScreen(BuildContext context, User user) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserDetailsScreen(user: user)),
    );
  }

  void navigateToUserFormScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserFormScreen()),
    );

    if (result == true) {
      fetchUserList();
    }
  }
}
