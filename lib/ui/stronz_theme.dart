import 'package:flutter/material.dart';

final ThemeData stronzTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: (Colors.grey[900])!,
    colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        primary: Colors.orange,
        secondary: Colors.grey,
        surface: Color(0xff121212),
        surfaceTint: Colors.transparent,
        surfaceContainerHigh: (Colors.grey[900])!,
        error: Colors.red,
        secondaryContainer: Colors.orange
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
        linearTrackColor: Colors.grey
    ),
    appBarTheme: AppBarTheme(
        centerTitle: true
    ),
    snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xff121212),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        contentTextStyle: TextStyle(
            color: Colors.white
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))
        )
    ),
    expansionTileTheme: ExpansionTileThemeData(
        shape: Border()
    ),
    cardTheme: CardTheme(
        clipBehavior: Clip.antiAlias,
    )
);
