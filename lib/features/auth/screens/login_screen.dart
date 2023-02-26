import 'package:chat/features/auth/controller/auth_controller.dart';
import 'package:chat/features/auth/screens/reset_password.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool isHiddenPassword = true;
  final loginController = TextEditingController();
  final passwordController = TextEditingController(text: '12345q');
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  void sendEmailAndPassword() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    String email = loginController.text.trim();
    String password = passwordController.text.trim();
    ref
        .read(authControllerProvider)
        .signInWithEmailAndPassword(context, email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Войти'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Spacer(flex: 1),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    controller: loginController,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Введите правильный Email'
                            : null,
                    decoration: const InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: IconTheme(
                            data: IconThemeData(color: Colors.grey),
                            child: Icon(Icons.email)),
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Введите Email',
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    autocorrect: false,
                    controller: passwordController,
                    obscureText: isHiddenPassword,
                    validator: (value) => value != null && value.length < 6
                        ? 'Минимум 6 символов'
                        : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Введите пароль',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: IconTheme(
                            data: IconThemeData(color: Colors.grey),
                            child: Icon(Icons.lock)),
                      ),
                      suffix: InkWell(
                        onTap: togglePasswordView,
                        child: Icon(
                          isHiddenPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: ElevatedButton(
                      onPressed: sendEmailAndPassword,
                      child: Text(
                        'Войти',
                        style: Theme.of(context).textTheme.button!.copyWith(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(
                        context, ResetPasswordScreen.routeName),
                    child: const Text('Сбросить пароль'),
                  ),
                  Spacer(),
                  Spacer(flex: 1)
                ]),
          ),
        ),
      ),
    );
    ;
  }
}
