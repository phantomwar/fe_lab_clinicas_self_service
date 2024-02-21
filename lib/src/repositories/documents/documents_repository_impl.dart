import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';

import './documents_repository.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  final RestClient restClient;

  DocumentsRepositoryImpl({required this.restClient});

  @override
  Future<Either<RepositoryException, String>> uploadImage(
      Uint8List file, String fileName) async {
    try {
      final formData = FormData.fromMap(
        {
          'file': MultipartFile.fromBytes(file, filename: fileName),
        },
      );
      final Response(data: {'url': pathImage}) =
          await restClient.post('/uploads', data: formData);

      return Right(pathImage);
    } on DioException catch (e, s) {
      log('Error ao fazer upload da imagem', error: e, stackTrace: s);
      return Left(RepositoryException());
    }
  }
}
