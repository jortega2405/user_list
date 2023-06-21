import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:user_list/bloc/user_bloc.dart';
import 'package:user_list/models/user_model.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = Provider.of<UserBloc>(context, listen: false);
    _userBloc.fetchUserList();
  }

  @override
  void dispose() {
    _userBloc.dispose();
    super.dispose();
  }

   @override
  void didUpdateWidget(UserListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_userBloc != null) {
      _userBloc.fetchUserList();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: StreamBuilder<List<User>>(
        stream: _userBloc.userListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userList = snapshot.data!;
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                return ListTile(
                  title: Text('Full Name: ${user.firstName} ${user.lastName}'),
                  subtitle: Text('DOB: ${DateFormat('yyyy/MM/dd').format(user.birthDate)}'),
                  trailing: const Icon(Icons.arrow_forward_ios_outlined),
                  onTap: () => _userBloc.navigateToUserDetailsScreen(context, user),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Not users found'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _userBloc.navigateToUserFormScreen(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
