import 'package:flutter/material.dart';

class BorderedText extends StatelessWidget {
    final String text;
    final Color borderColor;
    final double borderWidth;
    final TextStyle? textStyle;
    final TextAlign? textAlign;
    final TextDirection? textDirection;
    final TextScaler? textScaler;
    final TextOverflow? overflow;
    final int? maxLines;

    const BorderedText({
        super.key,
        required this.text,
        this.borderColor = Colors.black,
        this.borderWidth = 1,
        this.textStyle,
        this.textAlign,
        this.textDirection,
        this.textScaler,
        this.overflow,
        this.maxLines,
    });

    @override
    Widget build(BuildContext context) {
        TextStyle textStyle = DefaultTextStyle.of(context).style.merge(this.textStyle);
        return CustomPaint(
            size: Size(double.infinity, textStyle.fontSize! * 1.5),
            painter: _TextPainterWithBorder(
                text: this.text,
                borderColor: this.borderColor,
                borderWidth: this.borderWidth,
                textStyle: textStyle,
                textAlign: this.textAlign,
                textDirection: this.textDirection,
                textScaler: this.textScaler,
                overflow: this.overflow,
                maxLines: this.maxLines,
            ),
        );
    }
}

class _TextPainterWithBorder extends CustomPainter {
    final String text;
    final Color borderColor;
    final double borderWidth;
    final TextStyle textStyle;
    final TextAlign? textAlign;
    final TextDirection? textDirection;
    final TextScaler? textScaler;
    final TextOverflow? overflow;
    final int? maxLines;

    _TextPainterWithBorder({
        required this.text,
        required this.borderColor,
        required this.borderWidth,
        required this.textStyle,
        this.textAlign,
        this.textDirection,
        this.textScaler,
        this.overflow,
        this.maxLines,
    });

    @override
    void paint(Canvas canvas, Size size) {
        TextStyle borderTextStyle = this.textStyle.copyWith(
            foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = this.borderWidth
                ..color = this.borderColor,
        );

        TextPainter borderPainter = TextPainter(
            text: TextSpan(text: this.text, style: borderTextStyle),
            textAlign: this.textAlign ?? TextAlign.start,
            textDirection: this.textDirection ?? TextDirection.ltr,
            textScaler: this.textScaler ?? TextScaler.noScaling,
            maxLines: this.maxLines,
            ellipsis: this.overflow == TextOverflow.ellipsis ? '...' : null,
        );

        TextPainter mainTextPainter = TextPainter(
            text: TextSpan(text: this.text, style: this.textStyle),
            textAlign: this.textAlign ?? TextAlign.start,
            textDirection: this.textDirection ?? TextDirection.ltr,
            textScaler: this.textScaler ?? TextScaler.noScaling,
            maxLines: this.maxLines,
            ellipsis: this.overflow == TextOverflow.ellipsis ? '...' : null,
        );

        borderPainter.layout(maxWidth: size.width);
        mainTextPainter.layout(maxWidth: size.width);

        Offset offset = this._calculateOffset(borderPainter, size);

        borderPainter.paint(canvas, offset);
        mainTextPainter.paint(canvas, offset);
    }

    Offset _calculateOffset(TextPainter painter, Size size) {
        switch (painter.textAlign) {
            case TextAlign.center:
                return Offset(
                    (size.width - painter.width) / 2,
                    (size.height - painter.height) / 2,
                );
            case TextAlign.end:
                return Offset(
                    size.width - painter.width,
                    (size.height - painter.height) / 2,
                );
            case TextAlign.left:
                return Offset(
                    0,
                    (size.height - painter.height) / 2,
                );
            case TextAlign.right:
                return Offset(
                    size.width - painter.width,
                    (size.height - painter.height) / 2,
                );
            case TextAlign.justify:
            case TextAlign.start:
                return Offset(
                    0,
                    (size.height - painter.height) / 2,
                );
        }
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) {
        return true;
    }
}
