// ignore_for_file: use_build_context_synchronously, deprecated_member_use, library_private_types_in_public_api, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_fitness_pro/Authentication/login_screen.dart';
import 'package:my_fitness_pro/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        setState(() => isLoading = false);
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(nameController.text.trim());
        await user.reload();

        // Save user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': nameController.text.trim(),
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email already in use';
          break;
        case 'weak-password':
          message = 'Password should be at least 6 characters';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        default:
          message = 'Signup failed: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> signUpWithGoogle(BuildContext context) async {
    setState(() => isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        setState(() => isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Check if user already exists
      final List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(googleUser.email);

      if (signInMethods.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User already exists, please login instead.")),
        );
        setState(() => isLoading = false);
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser == true) {
      // New user signed up - proceed to HomeScreen or onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // Existing user tried to sign up - show message and navigate to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User already exists, please login instead.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Signup failed: ${e.toString()}")),
    );
  } finally {
    setState(() => isLoading = false);
  }
}

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/login_bg.jpg', fit: BoxFit.cover),
            Container(color: Colors.black.withOpacity(0.775)),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 70),
                        const Text(
                          "Welcome to My Fitness Pro",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Create Your Account",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Name
                        TextFormField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          autofillHints: const [AutofillHints.name],
                          validator: (value) => value!.isEmpty ? "Please enter your name" : null,
                          decoration: _buildInputDecoration("Name", Icons.person),
                        ),
                        const SizedBox(height: 10),

                        // Email
                        TextFormField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                          decoration: _buildInputDecoration("Email", Icons.email),
                        ),
                        const SizedBox(height: 10),

                        // Password
                        TextFormField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          style: const TextStyle(color: Colors.white),
                          autofillHints: const [AutofillHints.newPassword],
                          validator: (value) => value!.length < 6 ? "Password too short" : null,
                          decoration: _buildInputDecoration(
                            "Password",
                            Icons.lock,
                            isPasswordVisible,
                            () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Confirm Password
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: !isConfirmPasswordVisible,
                          style: const TextStyle(color: Colors.white),
                          autofillHints: const [AutofillHints.newPassword],
                          validator: (value) =>
                              value != passwordController.text ? "Passwords do not match" : null,
                          decoration: _buildInputDecoration(
                            "Confirm Password",
                            Icons.lock,
                            isConfirmPasswordVisible,
                            () {
                              setState(() {
                                isConfirmPasswordVisible = !isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Sign Up Button
                        ElevatedButton(
                          onPressed: isLoading ? null : signUp,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text("Sign Up"),
                        ),
                        const SizedBox(height: 20),

                        // Redirect to Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: isLoading ? null : () => signUpWithGoogle(context),
                              icon: const Icon(
                                FontAwesomeIcons.google,
                                color: Colors.red,
                              ),
                              label: const Text("Google"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Implement Facebook signup if needed
                              },
                              icon: const Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.blue,
                              ),
                              label: const Text("Facebook"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    String label,
    IconData icon, [
    bool? isVisible,
    VoidCallback? toggleVisibility,
  ]) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      prefixIcon: Icon(icon, color: Colors.white),
      suffixIcon: toggleVisibility != null
          ? IconButton(
              icon: Icon(
                isVisible! ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: toggleVisibility,
            )
          : null,
      filled: true,
      fillColor: Colors.black.withOpacity(0.3),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
