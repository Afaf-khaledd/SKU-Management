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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.03,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: screenHeight*0.2),
                  Text(
                    'Access Account',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth*0.06,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight*0.018),
                  Text(
                    'Login to your admin account',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth*0.04,
                      fontWeight: FontWeight.w400,
                      color: ColorsManager.subTextBlackColor,
                    ),
                  ),
                  SizedBox(height: screenHeight*0.04),
                  CustomFormField(
                    hintText: 'Your email address',
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                    validator: InputValidators.validateEmail,
                  ),
                  SizedBox(height: screenHeight*0.018),
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
                            fontSize: screenWidth*0.035,
                            fontWeight: FontWeight.w400,
                            color: ColorsManager.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.033),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return state is AuthLoading
                          ? const CircularProgressIndicator(color: ColorsManager.primaryColor,)
                          : CustomMainButton(
                        label: "Login",
                        onPressed: _submitForm,
                      );
                    },
                  ),
                  Center(
                    child: TextButton(
                      onPressed: (){context.go('/register');},
                      style: TextButton.styleFrom(
                        foregroundColor: ColorsManager.primaryColor,
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth*0.035,
                            fontWeight: FontWeight.w400,
                            color: ColorsManager.subTextBlackColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign up.',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth*0.033,
                                fontWeight: FontWeight.w500,
                                color: ColorsManager.primaryColor, // Highlighted color
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}