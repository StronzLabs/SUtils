import 'package:flutter/material.dart';

class CircularProgressButton extends StatelessWidget {
    
    final double borderPercentage;
    final bool autofocus;
    final void Function()? action;
    final IconData icon;

    const CircularProgressButton({
        super.key,
        required this.icon,
        this.borderPercentage = 0.0,
        this.autofocus = false,
        this.action
    });

    @override
    Widget build(BuildContext context) {
        return Stack(
            alignment: Alignment.center,
            children: [
                OutlinedButton(
                    onPressed: this.action,
                    style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10.0),
                        minimumSize: const Size(60, 60),
                        side: BorderSide(
                            width: 2,
                            color: Theme.of(context).disabledColor,
                        )
                    ),
                    autofocus: this.autofocus,
                    child: Icon(this.icon,
                        size: 30
                    )
                ),
                IgnorePointer(
                    child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                        value: this.borderPercentage,
                        strokeWidth: 2.0,
                    ),
                ),
                )
            ],
        );
    }
}