import 'dart:async';

final class DynamicLoadingStream {
    final Stream<dynamic> progress;
    final Completer<void> cancelled = Completer<void>();

    DynamicLoadingStream(this.progress);
}