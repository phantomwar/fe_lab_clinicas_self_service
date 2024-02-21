import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../model/patient_model.dart';
import '../../../repositories/patients/patient_repository.dart';

class PatientController with MessageStateMixin {
  final PatientRepository _repository;
  PatientController({required PatientRepository repository})
      : _repository = repository;

  PatientModel? patient;
  final _nextStep = signal<bool>(false);
  bool get nextStep => _nextStep();

  void goNextStep() {
    _nextStep.value = true;
  }

  void updateAndNext(PatientModel patient) async {
    final updateResult = await _repository.update(patient);
    switch (updateResult) {
      case Left():
        showError('Erro ao atualizar paciente, chame o atendente');

      case Right():
        showInfo('Paciente atualizado com sucesso');
        patient = patient;
        goNextStep();
    }
  }

  Future<void> saveAndNext(RegisterPatientModel patient) async {
    final result = await _repository.create(patient);
    switch (result) {
      case Left():
        showError('Erro ao cadastrar paciente, chame o atendente');
        break;
      case Right(value: final patient):
        showInfo('Paciente cadastrado com sucesso');
        this.patient = patient;
        goNextStep();
        break;
    }
  }
}
