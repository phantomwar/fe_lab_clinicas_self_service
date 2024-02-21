import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';

import '../../model/patient_model.dart';

typedef RegisterPatientAddressModel = ({
  String cep,
  String streetAddress,
  String city,
  String state,
  String district,
  String number,
  String addressComplement,
});

typedef RegisterPatientModel = ({
  String name,
  String email,
  String phoneNumber,
  String document,
  RegisterPatientAddressModel address,
  String guardian,
  String guardianIdentificationNumber
});

abstract interface class PatientRepository {
  Future<Either<RepositoryException, PatientModel?>> findPatientByDocument(
      String document);
  Future<Either<RepositoryException, Unit>> update(PatientModel patient);
  Future<Either<RepositoryException, PatientModel>> create(
      RegisterPatientModel patient);
}
