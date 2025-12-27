import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../../../widgets/app_input.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_loader.dart';
import '../../../utils/validators.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Obx(
        () => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppInput(
                      controller: emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    AppInput(
                      controller: passwordController,
                      label: 'Password',
                      obscureText: true,
                      validator: Validators.notEmpty,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Login',
                      loading: controller.loading.value,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          controller.login(
                            emailController.text,
                            passwordController.text,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.signup),
                      child: const Text('Don\'t have an account? Sign up'),
                    ),
                    if (controller.error.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          controller.error.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (controller.loading.value) const Center(child: AppLoader()),
          ],
        ),
      ),
    );
  }
}
