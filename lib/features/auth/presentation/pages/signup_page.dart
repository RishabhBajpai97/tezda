import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezda/core/utils/show_snackbar.dart';
import 'package:tezda/core/shared/widgets/loader.dart';
import 'package:tezda/core/theme/colors.dart';
import 'package:tezda/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tezda/features/auth/presentation/widgets/auth_field.dart';
import 'package:tezda/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:tezda/features/products/presentation/bloc/products/products_bloc.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: BlocConsumer<AuthBloc, AuthBlocState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  showSnackbar(context, state.message);
                } else if (state is AuthSuccess) {
                  context.read<ProductsBloc>().add(GetProductsEvent());
                  Navigator.of(context).pushReplacementNamed("/products-list");
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Loader();
                }
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign Up.",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AuthField(hintText: "Email", controller: emailController),
                      const SizedBox(
                        height: 30,
                      ),
                      AuthField(hintText: "Name", controller: nameController),
                      const SizedBox(
                        height: 30,
                      ),
                      AuthField(
                        hintText: "Password",
                        controller: passController,
                        isObscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthGradientButton(
                          buttonText: "Sign Up",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(AuthSignup(
                                  email: emailController.text,
                                  name: nameController.text,
                                  password: passController.text));
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: const TextStyle(
                                color: AppColors.gradient2,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, "/signin");
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
