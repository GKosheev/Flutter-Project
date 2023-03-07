import 'package:flutter/material.dart';
import 'package:myapp/constants/routes.dart';
import 'package:myapp/services/auth/auth_exceptions.dart';
import 'package:myapp/services/auth/auth_service.dart';
import '../show_error_snackbar.dart';
import '../show_success_snackbar.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text("Register")),
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
                    .createUser(email: email, password: password);

                await AuthService.firebase().sendEmailVerification();
                await AuthService.firebase().logOut();

                if (!mounted) {
                  return;
                }

                showSuccessSnackbar(
                    context, "Please check your email to verify your account");
                Navigator.of(context).pushNamed(loginRoute);
              } on WeakPasswordAuthException {
                showErrorSnackbar(
                  context,
                  "weak password, make it stronger 🤖",
                );
              } on EmailAlreadyInUseAuthException {
                showErrorSnackbar(
                  context,
                  "email already in use 🧐",
                );
              } on InvalidEmailAuthException {
                showErrorSnackbar(
                  context,
                  "this is an invalid email address 🧐",
                );
              } on GenericAuthException {
                showErrorSnackbar(context, "Failed to register 😈");
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                // RegisterView();
              },
              child: const Text("Already registered? Login here!"))
        ],
      ),
    );
  }
}
