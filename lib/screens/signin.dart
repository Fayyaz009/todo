import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_app/bloc/auth_bloc/bloc/auth_bloc.dart';
import 'package:testing_app/reuseable/custom_button.dart';
import 'package:testing_app/reuseable/texformfield.dart';
import 'package:testing_app/reuseable/validation_utils.dart';
import 'package:testing_app/screens/todo_screen.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            String id = state.userUid;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TodoScreen(id)),
            );
          }
        },
        builder: (context, state) => Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TexFormfield(
                  prefixIcon: Icon(Icons.email),
                  labelText: Text('Email'),
                  hintText: 'abc@gmail.com',
                  controller: _emailController,
                  onFieldSubmitted: (value) {},
                  validator: (value) => ValidationUtils.emailValidation(value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TexFormfield(
                  prefixIcon: Icon(Icons.password_sharp),
                  labelText: Text('Password'),
                  hintText: 'Abc123@',
                  controller: _passwordController,
                  onFieldSubmitted: (value) {},
                  validator: (value) =>
                      ValidationUtils.passwordValidation(value),
                ),
              ),
              CustomButton(
                buttonName: state is EmailLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('Sign In'),
                onPressed: state is EmailLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            AuthSigninWithEmailAndPasswordButton(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        }
                      },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Forgor your password?'),
                  TextButton(onPressed: () {}, child: Text('Reset')),
                ],
              ),
              // Professional OR Divider
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: state is AnonymousLoading
                        ? null
                        : () {
                            context.read<AuthBloc>().add(
                              AuthSignInAnonymouslyButton(),
                            );
                          },
                    child: Center(
                      child: state is AnonymousLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('Sign in Anonymously'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
