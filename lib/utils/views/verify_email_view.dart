import 'package:flutter/material.dart';
import 'package:myapp/constants/routes.dart';
import 'package:myapp/services/auth/auth_exceptions.dart';
import 'package:myapp/services/auth/auth_service.dart';
import 'package:myapp/utils/show_success_snackbar.dart';
import '../show_error_snackbar.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verification"),
        actions: [
          IconButton(
              onPressed: (() async {
                try {
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (_) => false,
                  );
                } on UserNotLoggedInAuthException {
                  showErrorSnackbar(context, "You are not logged in");
                } on GenericAuthException {
                  showErrorSnackbar(context, "Logout error 😈");
                }
              }),
              tooltip: "Logout",
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: const [
                  Text(
                      "We've sent you an email verification. Please open your email to verify your account."),
                  SizedBox(height: 15),
                  Text(
                      "If you haven't received a verification email, press the button below."),
                ],
              ),
            ),
            TextButton(
                onPressed: () async {
                  try {
                    await AuthService.firebase().sendEmailVerification();
                    await AuthService.firebase().logOut();

                    if (!mounted) {
                      return;
                    }
                    showSuccessSnackbar(context,
                        "Email has been sent. Please check your email and login again.");
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  } on UserNotLoggedInAuthException {
                    showErrorSnackbar(context, "You are not logged in");
                  } on GenericAuthException {
                    showErrorSnackbar(context, "Unexpected Error 😈");
                  }
                },
                child: const Text("Verify")),
          ],
        ),
      ),
    );
  }
}
