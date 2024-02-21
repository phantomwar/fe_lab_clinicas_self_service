import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/modules/self_service/self_service_controller.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/modules/self_service/widgets/lab_clinicas_self_service_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';
import 'package:brasil_fields/brasil_fields.dart';

import 'find_patient_controller.dart';

class FindPatientPage extends StatefulWidget {
  const FindPatientPage({super.key});

  @override
  State<FindPatientPage> createState() => _FindPatientPageState();
}

class _FindPatientPageState extends State<FindPatientPage>
    with MessageViewMixin {
  final formKey = GlobalKey<FormState>();
  final documentEC = TextEditingController();
  final controller = Injector.get<FindPatientController>();

  @override
  void initState() {
    messageListener(controller);
    effect(() {
      final FindPatientController(:patient, :patientNotFound) = controller;
      if (patient != null || patientNotFound != null) {
        Injector.get<SelfServiceController>().goToFormPatient(patient);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LabClinicasSelfServiceAppBar(),
      body: LayoutBuilder(
        builder: (_, constrains) {
          var sizeOf = MediaQuery.sizeOf(context);
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: constrains.maxHeight),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background_login.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(40),
                  width: sizeOf.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Image.asset('assets/images/logo_vertical.png'),
                        const SizedBox(
                          height: 48,
                        ),
                        TextFormField(
                          controller: documentEC,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CpfInputFormatter()
                          ],
                          validator: Validatorless.required('CPF obrigatorio'),
                          decoration: const InputDecoration(
                            labelText: 'Digite o CPF do paciente',
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Não sabe o CPF do paciente?',
                              style: TextStyle(
                                  color: AppTheme.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextButton(
                                onPressed: () {
                                  controller.continueWithoutDocument();
                                },
                                child: const Text(
                                  'Clique aqui',
                                  style: TextStyle(
                                    color: AppTheme.orange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          width: sizeOf.width * 0.8,
                          height: 48,
                          child: ElevatedButton(
                              onPressed: () {
                                final valid =
                                    formKey.currentState?.validate() ?? false;
                                if (valid) {
                                  controller
                                      .findPatientByDocument(documentEC.text);
                                }
                              },
                              child: const Text('CONTINUAR')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
