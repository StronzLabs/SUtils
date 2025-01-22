import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sutils/logic/data/dynamic_loading_stream.dart';

abstract class Initializable {
    late final Future<void> _initialized;
    final StreamController<dynamic> _progress = StreamController.broadcast();
    late final DynamicLoadingStream progress;
    Future<void> get initialized => this._initialized;

    Initializable([void Function(Initializable)? then]) {
        this._initialized = this.construct().then((_) {
            then?.call(this);
            this._progress.add(1.0);
            this._progress.close();
        }).onError((error, stackTrace) {
            this._progress.addError(error!, stackTrace);
        });

        this.progress = DynamicLoadingStream(this._progress.stream);
        this.progress.cancelled.future.then((_) => this.onCancel());
    }

    @protected
    void reportProgress(dynamic progress) => this._progress.add(progress);
    @protected
    void onCancel() {}
    @protected
    Future<void> construct() async {}
}
