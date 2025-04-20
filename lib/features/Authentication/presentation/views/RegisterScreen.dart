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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
      context.read<AuthBloc>().add(RegisterRequested(email: email, password: password));
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
                    'Welcome,',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth*0.06,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight*0.018),
                  Text(
                    'Create new Admin account',
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
                  SizedBox(height: screenHeight*0.022),
                  CustomFormField(
                    hintText: 'Your password',
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                    controller: passwordController,
                    validator: InputValidators.validatePassword,
                  ),
                  SizedBox(height: screenHeight*0.052),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return state is AuthLoading
                          ? const CircularProgressIndicator(color:ColorsManager.primaryColor,)
                          : CustomMainButton(
                        label: "Create Account",
                        onPressed: _submitForm,
                      );
                    },
                  ),
                  Center(
                    child: TextButton(
                      onPressed: (){context.go('/login');},
                      style: TextButton.styleFrom(
                        foregroundColor: ColorsManager.primaryColor,
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: "Already have an account?",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth*0.037,
                            fontWeight: FontWeight.w400,
                            color: ColorsManager.subTextBlackColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login.',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth*0.035,
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