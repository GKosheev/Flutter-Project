import 'package:flutter/material.dart';
import 'package:myapp/constants/routes.dart';
import 'package:myapp/services/auth/auth_exceptions.dart';
import 'package:myapp/services/auth/auth_service.dart';
import 'package:myapp/utils/show_error_snackbar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Enter your email"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter your password"),
          ),
          OutlinedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredentials = await AuthService.firebase()
                    .logIn(email: email, password: password);
                if (userCredentials.isEmailVerified == true && mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (_) => false,
                  );
                } else {
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                }
              } on UserNotFoundAuthException {
                showErrorSnackbar(context, "User not found");
              } on WrongPasswordAuthException {
                showErrorSnackbar(context, "Wrong credentials");
              } on GenericAuthException {
                showErrorSnackbar(context, "Authentication error 😈");
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                // RegisterView();
              },
              child: const Text("Not registered yet? Register here!"))
        ],
      ),
    );
  }
}
