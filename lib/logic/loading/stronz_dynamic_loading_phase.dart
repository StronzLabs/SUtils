import 'package:sutils/logic/data/dynamic_loading_stream.dart';
import 'package:sutils/logic/loading/stronz_loading_phase.dart';

class StronzDynamicLoadingPhase extends StronzLoadingPhase {
    final List<DynamicLoadingStream> Function() steps;

    const StronzDynamicLoadingPhase({
        required super.weight,
        required this.steps,
        super.allowedFails,
    });
}
