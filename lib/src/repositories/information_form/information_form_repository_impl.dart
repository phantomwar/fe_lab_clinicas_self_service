import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';

import '../../model/patient_model.dart';
import '../../model/self_service_model.dart';
import './information_form_repository.dart';

class InformationFormRepositoryImpl implements InformationFormRepository {
  final RestClient restClient;

  InformationFormRepositoryImpl({required this.restClient});

  @override
  Future<Either<RepositoryException, Unit>> register(
      SelfServiceModel model) async {
    try {
      final SelfServiceModel(
        :name!,
        :lastName!,
        patient: PatientModel(id: patientId)!,
        documents: {
          DocumentType.healthInsuranceCard: List(first: healthInsuranceCardDoc),
          DocumentType.medicalOrder: medicalOrderDocs,
        }!
      ) = model;

      await restClient.post(
        '/patientInformationForm',
        data: {
          'patient_id': patientId,
          'health_insurance_card': healthInsuranceCardDoc,
          'medical_order': medicalOrderDocs,
          'password': '$name $lastName',
          'date_created': DateTime.now().toIso8601String(),
          'status': 'Waiting',
          'test': []
        },
      );

      return Right(unit);
    } on DioException catch (e, s) {
      log('Erro ao finalizar formulário de auto atendimento',
          error: e, stackTrace: s);
      return Left(RepositoryException());
    }
  }
}
