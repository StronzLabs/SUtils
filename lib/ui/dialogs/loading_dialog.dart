import 'dart:async';

import 'package:flutter/material.dart';

class LoadingDialog {
    static Future<T> load<T>(BuildContext context, Future<T> Function() future) async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const PopScope(
                canPop: false,
                child: Dialog(
                    backgroundColor: Colors.transparent,
                    child: Center(
                        child: CircularProgressIndicator(),
                    )
                )
            )
        );

        T result = await future();
        if(context.mounted)
            Navigator.of(context).pop();
        return result;
    }

    static Future<T> progress<T>(BuildContext context, Stream<double> Function() stream) async {
        return await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: StreamBuilder(
                    stream: stream(),
                    builder: ((context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.done) {
                            Navigator.of(context).pop(snapshot.data);
                            return const SizedBox.shrink();
                        }

                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                const Text("Caricamento..."),
                                SizedBox(
                                    width: 200,
                                    child: LinearProgressIndicator(
                                        value: snapshot.data ?? 0,
                                    )
                                )
                            ]
                        );
                    })
                )
            )
        );
    }
}
