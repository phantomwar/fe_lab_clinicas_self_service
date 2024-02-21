import 'package:brasil_fields/brasil_fields.dart';
import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/modules/self_service/patient/patient_controller.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/modules/self_service/patient/patient_form_controller.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/modules/self_service/widgets/lab_clinicas_self_service_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

import '../../../model/self_service_model.dart';
import '../self_service_controller.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage>
    with MessageViewMixin, PatientFormController {
  final formKey = GlobalKey<FormState>();
  final selfServiceController = Injector.get<SelfServiceController>();
  final PatientController controller = Injector.get<PatientController>();

  late bool patientFound;
  late bool enableForm;

  @override
  void initState() {
    messageListener(controller);
    final SelfServiceModel(:patient) = selfServiceController.model;

    patientFound = patient != null;
    enableForm = !patientFound;

    effect(() {
      if (controller.nextStep) {
        selfServiceController.updatePatientAndGoDocument(controller.patient);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    disposeForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: LabClinicasSelfServiceAppBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 18),
            padding: const EdgeInsets.all(32),
            width: sizeOf.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.orange,
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(children: [
                Visibility(
                  visible: patientFound,
                  replacement: Image.asset('assets/images/lupa_icon.png'),
                  child: Image.asset('assets/images/check_icon.png'),
                ),
                const SizedBox(
                  height: 24,
                ),
                Visibility(
                  visible: patientFound,
                  replacement: const Text(
                    'Cadastro não encontrado',
                    style: AppTheme.titleSmallStyle,
                  ),
                  child: const Text(
                    'Cadastro encontrado',
                    style: AppTheme.titleSmallStyle,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Visibility(
                  visible: patientFound,
                  replacement: const Text(
                    'Preencha os dados abaixo:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.blue,
                    ),
                  ),
                  child: const Text(
                    'Confirmar dados do paciente',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.blue,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  readOnly: !enableForm,
                  controller: nameEC,
                  validator: Validatorless.required('Nome obrigatorio'),
                  decoration:
                      const InputDecoration(label: Text('Nome do paciente')),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                    readOnly: !enableForm,
                    controller: emailEC,
                    validator: Validatorless.multiple([
                      Validatorless.email('Email invalido'),
                      Validatorless.required('Email obrigatorio'),
                    ]),
                    decoration: const InputDecoration(label: Text('e-mail'))),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                    readOnly: !enableForm,
                    controller: phoneEC,
                    validator: Validatorless.required('Telefone obrigatorio'),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    decoration: const InputDecoration(
                        label: Text('Telefone de Contato'))),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                    readOnly: !enableForm,
                    controller: documentEC,
                    validator: Validatorless.required('CPF obrigatorio'),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter()
                    ],
                    decoration:
                        const InputDecoration(label: Text('Digite o CPF'))),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                    readOnly: !enableForm,
                    controller: cepEC,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CepInputFormatter()
                    ],
                    validator: Validatorless.required('CEP obrigatorio'),
                    decoration: const InputDecoration(label: Text('CEP'))),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                          readOnly: !enableForm,
                          controller: streetEC,
                          validator:
                              Validatorless.required('Endereço obrigatorio'),
                          decoration:
                              const InputDecoration(label: Text('Endereço'))),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Flexible(
                        flex: 1,
                        child: TextFormField(
                            readOnly: !enableForm,
                            controller: numberEC,
                            validator: Validatorless.required(
                                'Número do endereço obrigatorio'),
                            decoration:
                                const InputDecoration(label: Text('Número')))),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          readOnly: !enableForm,
                          controller: complementEC,
                          validator:
                              Validatorless.required('Complemento obrigatorio'),
                          decoration: const InputDecoration(
                              label: Text('Complemento'))),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                          readOnly: !enableForm,
                          controller: stateEC,
                          validator:
                              Validatorless.required('Estado obrigatorio'),
                          decoration:
                              const InputDecoration(label: Text('Estado'))),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          readOnly: !enableForm,
                          controller: cityEC,
                          validator:
                              Validatorless.required('Cidade obrigatorio'),
                          decoration:
                              const InputDecoration(label: Text('Cidade'))),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                          readOnly: !enableForm,
                          controller: districtEC,
                          validator:
                              Validatorless.required('Bairro obrigatorio'),
                          decoration:
                              const InputDecoration(label: Text('Bairro'))),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  readOnly: !enableForm,
                  controller: guardianEC,
                  decoration: const InputDecoration(label: Text('Responsavel')),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  readOnly: !enableForm,
                  controller: guardianIdentificationNumberEC,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter()
                  ],
                  decoration: const InputDecoration(
                      label: Text('Responsável Identificação')),
                ),
                const SizedBox(
                  height: 32,
                ),
                Visibility(
                  visible: !enableForm,
                  replacement: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                        onPressed: () {
                          final valid =
                              formKey.currentState?.validate() ?? false;
                          if (valid) {
                            controller.updateAndNext(updatePatient(
                                selfServiceController.model.patient!));
                          } else {
                            controller.saveAndNext(createPatientRegister());
                          }
                        },
                        child: Visibility(
                            visible: !patientFound,
                            replacement: const Text('SALVAR E CONTINUAR'),
                            child: const Text('CADASTRAR'))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    enableForm = true;
                                  });
                                },
                                child: const Text('EDITAR'))),
                      ),
                      const SizedBox(
                        width: 17,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                              onPressed: () {
                                controller.patient =
                                    selfServiceController.model.patient;
                                controller.goNextStep();
                              },
                              child: const Text('CONTINUAR')),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
