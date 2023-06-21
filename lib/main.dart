import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_list/bloc/user_bloc.dart';
import 'package:user_list/models/user_model.dart';
import 'package:user_list/screens/user_details_screen.dart';
import 'package:user_list/screens/user_list_screen.dart';
import 'package:user_list/screens/user_form_screen.dart';

void main() {
  runApp(
   const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserBloc>(
          create: (_) => UserBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'User List',
        initialRoute: '/',
        routes: {
          '/': (context) => const UserListScreen(),
          '/user-form': (context) => const UserFormScreen(),
          '/user-details': (context) {
            final user = ModalRoute.of(context)?.settings.arguments as User;
            return UserDetailsScreen(user: user);
          },
        },
      ),
    );
  }
}


