import 'dart:async';
import 'dart:developer';

import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/modules/auth/auth_module.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/modules/home/home_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

import 'src/binding/lab_clinicas_application_binding.dart';
import 'src/pages/splash_page/splash_page.dart';

void main() {
  runZonedGuarded(() {
    runApp(const LabClininasSelfServiceApp());
  }, (error, stack) {
    log('Erro não tratado', error: error, stackTrace: stack);
    throw error;
  });
}

class LabClininasSelfServiceApp extends StatelessWidget {
  const LabClininasSelfServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LabClinicasCoreConfig(
      title: 'Lab Clinicas Self Service',
      bindings: LabClinicasApplicationBinding(),
      pagesBuilders: [
        FlutterGetItPageBuilder(page: (_) => const SplashPage(), path: '/')
      ],
      modules: [
        AuthModule(),
        HomeModule(),
      ],
    );
  }
}
