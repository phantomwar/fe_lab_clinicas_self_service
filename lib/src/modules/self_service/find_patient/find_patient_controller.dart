// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';

import 'package:fe_lab_clinicas_self_service_cb/src/repositories/patients/patient_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../model/patient_model.dart';

class FindPatientController with MessageStateMixin {
  final PatientRepository _patientRepository;

  FindPatientController({
    required PatientRepository patientRepository,
  }) : _patientRepository = patientRepository;

  final _patientNotFound = ValueSignal<bool?>(null);
  final _patient = ValueSignal<PatientModel?>(null);

  bool? get patientNotFound => _patientNotFound();
  PatientModel? get patient => _patient();

  Future<void> findPatientByDocument(String document) async {
    final patientResult =
        await _patientRepository.findPatientByDocument(document);

    bool patientNotFound;
    PatientModel? patient;

    switch (patientResult) {
      case Right(value: PatientModel model?):
        patientNotFound = false;
        patient = model;
      case Right(value: _):
        patientNotFound = true;
        patient = null;
      case Left():
        showError('Erro ao buscar pacient');
        return;
    }
    batch(() {
      _patient.value = patient;
      _patientNotFound.value = patientNotFound;
    });
  }

  void continueWithoutDocument() {
    batch(() {
      _patient.value = null;
      _patientNotFound.value = true;
    });
  }
}
