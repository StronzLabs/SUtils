import 'dart:async';
import 'package:sutils/ui/pages/stronz_loading_phase.dart';

class StronzStaticLoadingPhase extends StronzLoadingPhase {
    final List<Future<dynamic>> steps;

    const StronzStaticLoadingPhase({
        required super.weight,
        required this.steps,
        super.allowedFails,
    });
}
