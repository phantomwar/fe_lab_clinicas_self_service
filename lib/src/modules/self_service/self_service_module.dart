import 'package:fe_lab_clinicas_self_service_cb/src/modules/self_service/done/done_page.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/modules/self_service/find_patient/find_patient_router.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/modules/self_service/patient/patient_router.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/modules/self_service/self_service_controller.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/repositories/information_form/information_form_repository.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/repositories/information_form/information_form_repository_impl.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/repositories/patients/patient_repository.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/repositories/patients/patient_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

import 'documents/documents_page.dart';
import 'documents/scan/documents_scan_page.dart';
import 'documents/scan_confirm/documents_scan_confirm_page.dart';

import 'self_service_page.dart';
import 'who_i_am/who_i_am_page.dart';

class SelfServiceModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<InformationFormRepository>(
            (i) => InformationFormRepositoryImpl(restClient: i())),
        Bind.lazySingleton(
            (i) => SelfServiceController(informationFormRepository: i())),
        Bind.lazySingleton<PatientRepository>(
            (i) => PatientRepositoryImpl(restClient: i()))
      ];

  @override
  String get moduleRouteName => '/self-service';

  @override
  Map<String, WidgetBuilder> get pages => {
        '/': (_) => const SelfServicePage(),
        '/who-i-am': (_) => const WhoIAmPage(),
        '/find-patient': (_) => const FindPatientRouter(),
        '/patient': (_) => const PatientRouter(),
        '/documents': (_) => const DocumentsPage(),
        '/documents/scan': (_) => const DocumentsScanPage(),
        '/documents/scan/confirm': (_) => DocumentsScanConfirmPage(),
        '/done': (_) => DonePage(),
      };
}
