import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sku/core/components/customMainButton.dart';
import 'package:sku/core/helper/input_validators.dart';
import '../../../../core/components/customFormField.dart';
import '../../../../core/utils/colors.dart';
import '../logic/auth_bloc.dart';
import '../logic/auth_event.dart';
import '../logic/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      context.read<AuthBloc>().add(LoginRequested(email: email, password: password));
    }
  }

  void _resetPassword() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email to reset password.')),
      );
    } else {
      context.read<AuthBloc>().add(ResetPasswordRequested(email: email));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('We’ve sent you a password reset email. Please check your inbox.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.go('/home');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 160),
                  Text(
                    'Access Account',
                    style: GoogleFonts.poppins(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Login to your admin account',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: ColorsManager.subTextBlackColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomFormField(
                    hintText: 'Your email address',
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                    validator: InputValidators.validateEmail,
                  ),
                  const SizedBox(height: 20),
                  CustomFormField(
                    hintText: 'Your password',
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                    controller: passwordController,
                    validator: InputValidators.validatePassword,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: _resetPassword,
                        style: TextButton.styleFrom(
                          foregroundColor: ColorsManager.primaryColor,
                        ),
                        child: Text(
                          "Forget your password?",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: ColorsManager.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return state is AuthLoading
                          ? const CircularProgressIndicator(color: Colors.white,)
                          : CustomMainButton(
                        label: "Login",
                        onPressed: _submitForm,
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}