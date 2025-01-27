import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:sutils/logic/data/dynamic_loading_stream.dart';
import 'package:sutils/logic/errors/stronz_loading_early_fail.dart';
import 'package:sutils/logic/errors/stronz_loading_warn.dart';
import 'package:sutils/logic/loading/stronz_dynamic_loading_phase.dart';
import 'package:sutils/logic/update/version.dart';
import 'package:sutils/src/update/updater.dart';
import 'package:sutils/sutils.dart';
import 'package:sutils/ui/dialogs/confirmation_dialog.dart';
import 'package:sutils/logic/loading/stronz_loading_phase.dart';
import 'package:sutils/logic/loading/stronz_static_loading_phase.dart';
import 'package:sutils/utils.dart';

class StronzLoadingPage extends StatefulWidget {
    final Widget splash;
    final List<StronzLoadingPhase> phases;
    final Future<void> Function()? onOffline;
    final Future<void> Function()? backgroundLoading;

    const StronzLoadingPage({
        required this.splash,
        required this.phases,
        this.onOffline,
        this.backgroundLoading,
        super.key
    });

    @override
    State<StronzLoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<StronzLoadingPage> with SingleTickerProviderStateMixin {
    
    late final AnimationController _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
    );

    late Animation<double> _animation = Tween<double>(
        begin: this._currentPercentage,
        end: this._currentPercentage
    ).animate(this._animationController);

    double _currentPercentage = 0.0;
    String? _error;
    Timer? _additionalInfoTimer;
    bool _showAdditionalInfo = false;

    String _splash = "Caricamento dei contenuti";
    bool _update = false;

    void _startUpdate() {
        this._update = true;
        this._splash = "Aggiornamento in corso";
    }

    Stream<double> _staticLoad(List<Future<dynamic>> loadingPhase, int allowedFails) async* {
        int fails = 0;
        for (int i = 0; i < loadingPhase.length; i++) {
            await loadingPhase[i].onError((error, stackTrace) {
                if (error is! StronzLoadingWarn)
                    throw error!;
                
                if(super.mounted) {
                    ScaffoldMessenger.of(super.context).showSnackBar(SnackBar(
                        content: Text(error.message),
                        width: 300,
                    ));
                }

                fails++;
            });

            yield (i + 1) / loadingPhase.length;
        }

        if(fails > allowedFails)
            throw "Molteplici errori durante il caricamento. Riprova più tardi";
    }

    Stream<double> _dynamicLoad(List<DynamicLoadingStream> loadingPhase, int allowedFails) async* {
        StreamController<(int, double)> loading = StreamController.broadcast();
        int succeeds = 0, fails = 0;

        List<StreamSubscription> subscriptions = loadingPhase.map((stream) {

            int index = loadingPhase.indexOf(stream);
            late StreamSubscription subscription;
            subscription = stream.progress.listen(
                (percentage) async {
                    if(loading.isClosed)
                        return;

                    if(percentage is StronzLoadingEarlyFail) {
                        if(!super.mounted)
                            return;

                        bool goOn = await ConfirmationDialog.ask(
                            context: super.context,
                            title: "Avviso",
                            text: percentage.message,
                            confirm: "Forza il caricamento",
                            cancel: "Continua senza"
                        );

                        if(!goOn) {                            
                            if(++fails > allowedFails)
                                return loading.addError("Molteplici errori durante il caricamento. Riprova più tardi");

                            if(++succeeds == loadingPhase.length)
                                loading.close();

                            subscription.cancel();
                            stream.cancelled.complete();
                        }

                        return;
                    }

                    loading.add(( index, percentage ));
                },
                onDone: () {
                    if(loading.isClosed)
                        return;
                    loading.add(( index, 1.0 ));
                    if(++succeeds == loadingPhase.length && fails <= allowedFails)
                        loading.close();
                },
                onError: (error, stackTrace) {
                    if(loading.isClosed)
                        return;

                    if (error is! StronzLoadingWarn)
                        return loading.addError(error, stackTrace);
                
                    if(super.mounted) {
                        ScaffoldMessenger.of(super.context).showSnackBar(SnackBar(
                            content: Text(error.message),
                            width: 300,
                        ));
                    }

                    if(++fails > allowedFails)
                        return loading.addError("Molteplici errori durante il caricamento. Riprova più tardi");

                    if(++succeeds == loadingPhase.length)
                        loading.close();
                },
            );

            return subscription;
        }).toList();
        
        List<double> advance = List.filled(loadingPhase.length, 0.0);
        await for ((int, double) percentage in loading.stream) {
            advance[percentage.$1] = percentage.$2 / loadingPhase.length;
            yield advance.reduce((a, b) => a + b);
        }

        for (StreamSubscription subscription in subscriptions)
            subscription.cancel();
    }

    Future<bool> _isOffline() async {
        return (await Connectivity().checkConnectivity()).contains(ConnectivityResult.none);
    }

    Future<bool> _askForOffline() async {
        return await ConfirmationDialog.ask(
            context: super.context,
            title: "Connessione Assente",
            text: "Non è presente una connessione ad internet. Vuoi continuare in modalità offline?"
        );
    }

    Future<Stream<double>?> _askForUpdate() async {
        bool wantUpdate = await ConfirmationDialog.ask(
            context: super.context,
            title: "Aggiornamento Disponibile",
            content: TextSpan(
                children: [
                    TextSpan(
                        text: "Una nuova versione è disponibile.\n",
                    ),
                    TextSpan(
                        text: "Vuoi aggiornare?",
                    )
                ]
            ),
            cancel: "Ignora",
            confirm: EPlatform.isMobile ? "Installa" : "Scarica"
        );

        if(wantUpdate)
            return Updater.update();

        return null;
    }

    Stream<double> _doLoading() async* {
        double advance = 0.0;

        if(await this._isOffline()) {
            if(super.widget.onOffline != null && await this._askForOffline())
                await super.widget.onOffline!();
            else
                throw "Connessione Assente";
        }

        if(await VersionChecker.shouldUpdate()) {
            Stream<double>? updatePercentage = await this._askForUpdate();
            if(updatePercentage != null) {
                this._startUpdate();
                await for (double percentage in updatePercentage)
                    yield percentage;
                return;
            }
        }

        this._additionalInfoTimer = Timer(Duration(seconds: 5), () {
            if(super.mounted)
                super.setState(() => this._showAdditionalInfo = true);
        });

        for(StronzLoadingPhase phase in super.widget.phases) {
            if(phase is StronzStaticLoadingPhase)
                await for (double percentage in this._staticLoad(phase.steps(), phase.allowedFails))
                    yield advance + percentage * phase.weight;
            else if (phase is StronzDynamicLoadingPhase)
                await for (double percentage in this._dynamicLoad(phase.steps(), phase.allowedFails))
                    yield advance + percentage * phase.weight; 
            else
                throw Exception("Unknown loading phase type");

            advance += phase.weight;
        }

        yield advance;
    }

    void _foregrunLoading() async {
        this._doLoading().listen(
            (percentage) {
                super.setState(() {
                    this._animation = Tween<double>(
                        begin: this._currentPercentage,
                        end: percentage
                    ).animate(this._animationController);
                    this._currentPercentage = percentage;
                });
                this._animationController.forward(from: 0);
            },
            cancelOnError: true,
            onError: (error, stacktrace) => super.setState(
                () => this._error = error.toString()
            ),
            onDone: () {
                if(!this._update && super.mounted)
                    Navigator.of(super.context).pushReplacementNamed("/home");
            }
        );
    }

    @override
    void initState() {
        super.initState();
        SafeWakelock.enable();

        // TODO: https://stackoverflow.com/a/73615773/10064643 https://github.com/flutter/flutter/issues/107416
        FlutterError.onError = (details) {
            if (details.exception is! NetworkImageLoadException)
                throw details.exception;
        };

        SUtils.ensureInitialized().then((_) {
            this._foregrunLoading();
            super.widget.backgroundLoading?.call();
        });
    }

    @override
    void dispose() {
        this._animationController.dispose();
        this._additionalInfoTimer?.cancel();
        SafeWakelock.disable();
        super.dispose();
    }

    Widget _buildError(BuildContext context) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Icon(Icons.error,
                            color: Theme.of(context).colorScheme.error,
                            size: 30,
                        ),
                        SizedBox(width: 10),
                        Text("Errore",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.error
                            ),
                            textAlign: TextAlign.center
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.error,
                            color: Theme.of(context).colorScheme.error,
                            size: 30
                        )
                    ]
                ),
                Text(this._error!,
                    key: Key("loading_error"),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error
                    ),
                    textAlign: TextAlign.center
                ),
            ],
        );
    }

    Widget _buildLoading(BuildContext context) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Text(this._splash,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary
                    ),
                    textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                SizedBox(
                    width: 700,
                    child: AnimatedBuilder(
                        animation: this._animation,
                        builder: (context, child) => LinearProgressIndicator(
                            value: this._animation.value,
                        )
                    )
                ),
                SizedBox(height: 20),
                Text(this._showAdditionalInfo
                    ? "Caricamento in corso, potrebbero volerci alcuni minuti"
                    : "",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                )
            ]
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Padding(
                padding: EdgeInsets.all(30),
                child: Stack(
                    alignment: Alignment.center,
                    children: [
                        Center(
                            child: super.widget.splash,
                        ),
                        Positioned(
                            top: MediaQuery.of(context).size.height / 2 + 75,
                            width: MediaQuery.of(context).size.width - 30,
                            child: this._error != null
                                    ? this._buildError(context)
                                    : this._buildLoading(context),
                        ),
                    ]
                )
            )
        );
    }
}
