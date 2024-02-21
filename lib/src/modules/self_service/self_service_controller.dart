import 'package:asyncstate/asyncstate.dart';
import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/model/patient_model.dart';
import 'package:fe_lab_clinicas_self_service_cb/src/repositories/information_form/information_form_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../model/self_service_model.dart';

enum FormSteps {
  none,
  whoIAm,
  findPatient,
  patient,
  documents,
  done,
  restart,
}

class SelfServiceController with MessageStateMixin {
  final InformationFormRepository _informationFormRepository;

  SelfServiceController(
      {required InformationFormRepository informationFormRepository})
      : _informationFormRepository = informationFormRepository;

  final _step = ValueSignal(FormSteps.none);
  FormSteps get step => _step();

  var _model = const SelfServiceModel();
  SelfServiceModel get model => _model;

  var password = '';

  void startProcess() => _step.forceUpdate(FormSteps.whoIAm);

  void setWhoIAmDataStepAndNext(String name, String lastname) {
    _model = _model.copyWith(name: () => name, lastName: () => lastname);
    _step.forceUpdate(FormSteps.findPatient);
  }

  void goToFormPatient(PatientModel? patient) {
    _model = _model.copyWith(patient: () => patient);
    _step.forceUpdate(FormSteps.patient);
  }

  void clearForm() {
    _model = _model.clear();
  }

  void restartProcess() {
    _step.forceUpdate(FormSteps.restart);
    clearForm();
  }

  void updatePatientAndGoDocument(PatientModel? patient) {
    _model = _model.copyWith(patient: () => patient);
    _step.forceUpdate(FormSteps.documents);
  }

  void registerDocuments(DocumentType type, String filePath) {
    final documents = _model.documents ?? {};
    if (type == DocumentType.healthInsuranceCard) {
      documents[type]?.clear();
    }
    final values = documents[type] ?? [];
    values.add(filePath);
    documents[type] = values;
    _model = _model.copyWith(documents: () => documents);
  }

  void clearDocuments() {
    _model = _model.copyWith(documents: () => {});
  }

  Future<void> finalize() async {
    final result =
        await _informationFormRepository.register(model).asyncLoader();
    switch (result) {
      case Left():
        showError('Erro ao registrar informação, chame o atendente');
      case Right():
        password = '${_model.name} ${_model.lastName}';
        _step.forceUpdate(FormSteps.done);
    }
  }
}
