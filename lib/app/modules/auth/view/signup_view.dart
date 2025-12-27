import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../../../widgets/app_input.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_loader.dart';
import '../../../utils/validators.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class SignupView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
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
                      controller: nameController,
                      label: 'Name',
                      validator: Validators.notEmpty,
                    ),
                    const SizedBox(height: 16),
                    AppInput(
                      controller: emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    AppInput(
                      controller: phoneController,
                      label: 'Phone',
                      keyboardType: TextInputType.phone,
                      validator: Validators.phone,
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
                      label: 'Sign Up',
                      loading: controller.loading.value,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          controller.signup(
                            emailController.text,
                            passwordController.text,
                            nameController.text,
                            phoneController.text,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.login),
                      child: const Text('Already have an account? Login'),
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
