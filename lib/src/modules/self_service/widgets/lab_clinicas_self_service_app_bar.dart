import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

import '../self_service_controller.dart';

class LabClinicasSelfServiceAppBar extends AppCustomAppBar {
  LabClinicasSelfServiceAppBar({super.key})
      : super(actions: [
          PopupMenuButton(
            child: const IconPopupMenuWidget(),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 1,
                child: Text('Reiniciar Processo'),
              ),
            ],
            onSelected: (value) async {
              Injector.get<SelfServiceController>().restartProcess();
            },
          )
        ]);
}
