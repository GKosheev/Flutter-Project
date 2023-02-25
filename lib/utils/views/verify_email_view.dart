import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants/routes.dart';
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
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (_) => false,
                  );
                } on FirebaseAuthException catch (e) {
                  showErrorSnackbar(context, e.code.toString());
                } catch (e) {
                  showErrorSnackbar(context, "Unexpected Error 😈");
                }
              }),
              tooltip: "Logout",
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Please verify your email address"),
            TextButton(
                onPressed: () async {
                  try {
                    final user = FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();
                  } on FirebaseAuthException catch (e) {
                    showErrorSnackbar(context, e.code.toString());
                  } catch (e) {
                    showErrorSnackbar(context, "Unexpected Error 😈");
                  }
                },
                child: const Text("Verify"))
          ],
        ),
      ),
    );
  }
}
