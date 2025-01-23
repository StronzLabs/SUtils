import 'dart:async';
import 'package:sutils/logic/loading/stronz_loading_phase.dart';

class StronzStaticLoadingPhase extends StronzLoadingPhase {
    final List<Future<dynamic>> Function() steps;

    const StronzStaticLoadingPhase({
        required super.weight,
        required this.steps,
        super.allowedFails,
    });
}
