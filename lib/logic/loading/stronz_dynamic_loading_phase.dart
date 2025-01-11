import 'dart:async';
import 'package:sutils/ui/pages/stronz_loading_phase.dart';

class StronzDynamicLoadingPhase extends StronzLoadingPhase {
    final List<Stream<dynamic>> steps;

    const StronzDynamicLoadingPhase({
        required super.weight,
        required this.steps,
        super.allowedFails,
    });
}
