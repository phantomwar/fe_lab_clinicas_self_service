import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

import '../../../model/self_service_model.dart';
import '../self_service_controller.dart';
import '../widgets/lab_clinicas_self_service_app_bar.dart';
import 'widgets/document_box_widget.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> with MessageViewMixin {
  final selfServiceController = Injector.get<SelfServiceController>();

  @override
  void initState() {
    messageListener(selfServiceController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);

    final documents = selfServiceController.model.documents;

    final medicalOrder = documents?[DocumentType.medicalOrder]?.length ?? 0;
    final totalHealthInsuranceCard =
        documents?[DocumentType.healthInsuranceCard]?.length ?? 0;

    return Scaffold(
      appBar: LabClinicasSelfServiceAppBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: sizeOf.width * 0.85,
            margin: const EdgeInsets.only(top: 18),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.orange),
            ),
            child: Column(
              children: [
                Image.asset('assets/images/folder.png'),
                const SizedBox(height: 24),
                const Text('ADICIONAR DOCUMENTOS',
                    style: AppTheme.titleSmallStyle),
                const SizedBox(height: 32),
                const Text(
                  'Selecione o documento que deseja fotografar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.blue,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: sizeOf.width * 0.8,
                  height: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DocumentBoxWidget(
                        uploaded: totalHealthInsuranceCard > 0,
                        icon: Image.asset('assets/images/id_card.png'),
                        label: 'CARTEIRINHA',
                        totalFiles: totalHealthInsuranceCard,
                        onTap: () async {
                          final filePath = await Navigator.of(context)
                              .pushNamed('/self-service/documents/scan');
                          if (filePath != null && filePath != '') {
                            selfServiceController.registerDocuments(
                                DocumentType.healthInsuranceCard,
                                filePath.toString());
                            setState(() {});
                          }
                        },
                      ),
                      const SizedBox(width: 32),
                      DocumentBoxWidget(
                        uploaded: medicalOrder > 0,
                        icon: Image.asset('assets/images/document.png'),
                        label: 'PEDIDO MEDICO',
                        totalFiles: medicalOrder,
                        onTap: () async {
                          final filePath = await Navigator.of(context)
                              .pushNamed('/self-service/documents/scan');
                          if (filePath != null && filePath != '') {
                            selfServiceController.registerDocuments(
                                DocumentType.medicalOrder, filePath.toString());
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: totalHealthInsuranceCard > 0 && medicalOrder > 0,
                    child: const SizedBox(height: 24)),
                Visibility(
                  visible: totalHealthInsuranceCard > 0 && medicalOrder > 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            selfServiceController.clearDocuments();
                            setState(() {});
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            fixedSize: const Size.fromHeight(48),
                          ),
                          child: const Text('REMOVER TODAS'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await selfServiceController.finalize();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.orange,
                            fixedSize: const Size.fromHeight(48),
                          ),
                          child: const Text("FINALIZAR"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
