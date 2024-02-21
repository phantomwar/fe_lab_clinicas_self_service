import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

import 'package:signals_flutter/signals_flutter.dart';

import '../../widgets/lab_clinicas_self_service_app_bar.dart';
import 'documents_scan_confirm_controller.dart';

class DocumentsScanConfirmPage extends StatelessWidget {
  final controller = Injector.get<DocumentsScanConfirmController>();

  DocumentsScanConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);
    final foto = ModalRoute.of(context)!.settings.arguments as XFile;

    controller.pathRemoteStorage.listen(context, () {
      Navigator.of(context).pop();
      Navigator.of(context).pop(controller.pathRemoteStorage.value);
    });

    return Scaffold(
      appBar: LabClinicasSelfServiceAppBar(),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: sizeOf.width * 0.85,
              margin: const EdgeInsets.only(top: 18),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.orange),
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/foto_confirm_icon.png'),
                  const SizedBox(height: 15),
                  const Text('CONFIRA SUA FOTO',
                      style: AppTheme.titleSmallStyle),
                  const SizedBox(height: 32),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      strokeWidth: 4,
                      strokeCap: StrokeCap.square,
                      color: AppTheme.orange,
                      dashPattern: const [1, 10, 1, 3],
                      radius: const Radius.circular(16),
                      child: Image.file(
                        File(foto.path),
                        width: sizeOf.width * 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('TIRAR NOVAMENTE'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                              onPressed: () async {
                                final imageBytes = await foto.readAsBytes();
                                final fileName = foto.name;
                                await controller.uploadImage(
                                    imageBytes, fileName);
                              },
                              child: const Text('SALVAR')),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
