import 'package:flutter/material.dart';
import 'package:ready_ecommerce/views/common/authentication/layouts/recover_password_layout.dart';

class RecoverPasswordView extends StatelessWidget {
  final bool isPasswordRecovery;
  const RecoverPasswordView({super.key, required this.isPasswordRecovery});

  @override
  Widget build(BuildContext context) {
    return RecoverPasswordLayout(
      isPasswordRecover: isPasswordRecovery,
    );
  }
}
