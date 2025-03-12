import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sutils/ui/widgets/animated_expanding_container.dart';
import 'package:sutils/utils.dart';

class ExpandableText extends StatefulWidget {
    final String text;
    final TextStyle? style;
    final String? expandedLabel;
    final String? collapsedLabel;
    final int maxLines;
    final TextAlign? textAlign;
    final TextDirection? textDirection;
    final bool initiallyExpanded;
    final void Function()? onTvFocus;
    final bool autofocus;

    const ExpandableText(this.text, {
        super.key,
        required this.maxLines,
        this.expandedLabel,
        this.collapsedLabel,
        this.style,
        this.textAlign,
        this.textDirection,
        this.initiallyExpanded = false,
        this.onTvFocus,
        this.autofocus = false
    });

    @override
    State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {

    late bool _expanded = super.widget.initiallyExpanded;

    TextStyle get _textStyle => super.widget.style == null || super.widget.style!.inherit
            ? DefaultTextStyle.of(context).style.merge(widget.style) : super.widget.style!;

    TextAlign get _textAlign => super.widget.textAlign ?? DefaultTextStyle.of(context).textAlign ?? TextAlign.start;
    TextDirection get _textDirection => super.widget.textDirection ?? Directionality.of(context);
    TextScaler get _textScaler => MediaQuery.textScalerOf(context);
    Locale? get _locale => Localizations.maybeLocaleOf(context);

    TextSpan _buildLink(BuildContext context, TextStyle effectiveTextStyle) {
        String linkText = (this._expanded ? super.widget.expandedLabel : super.widget.collapsedLabel ) ?? '';
        Color linkColor = Theme.of(context).colorScheme.primary;
        TextStyle linkTextStyle = effectiveTextStyle.merge(super.widget.style).copyWith(color: linkColor);

        return TextSpan(
            children: [
                if (!this._expanded)
                    TextSpan(
                        text: '\u2026 ',
                        style: linkTextStyle
                    ),
                if (linkText.isNotEmpty)
                    TextSpan(
                        style: effectiveTextStyle,
                        children: [
                            if (_expanded)
                                const TextSpan(text: ' '),
                            TextSpan(
                                text: linkText,
                                style: linkTextStyle
                            ),
                        ],
                    ),
            ],
        );
    }

    Widget _buildContent(BuildContext context) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
                assert(constraints.hasBoundedWidth);

                double maxWidth = constraints.maxWidth;
                TextSpan content = TextSpan(
                    text: super.widget.text,
                    style: this._textStyle
                );
                TextPainter textPainter = TextPainter(
                    textAlign: this._textAlign,
                    textDirection: this._textDirection,
                    textScaler: this._textScaler,
                    locale: this._locale,
                    maxLines: super.widget.maxLines,
                );

                TextSpan link = this._buildLink(context, this._textStyle);
                textPainter.text = link;
                textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
                Size linkSize = textPainter.size;

                textPainter.text = content;
                textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
                Size textSize = textPainter.size;

                TextPosition position = textPainter.getPositionForOffset(Offset(
                    textSize.width - linkSize.width,
                    textSize.height,
                ));
                int endOffset = textPainter.getOffsetBefore(position.offset) ?? 0;

                Widget buildText(BuildContext context, bool expanded) {
                    return RichText(
                        text: TextSpan(
                            children: [
                                TextSpan(
                                    text: expanded
                                        ? super.widget.text
                                        : super.widget.text.substring(0, max(endOffset, 0)),
                                    style: this._textStyle
                                ),
                                if(textPainter.didExceedMaxLines)
                                    link
                            ]
                        ),
                        softWrap: true,
                        textDirection: this._textDirection,
                        textAlign: this._textAlign,
                        textScaler : this._textScaler,
                        overflow: TextOverflow.clip,
                    );
                }

                if (!textPainter.didExceedMaxLines)
                    return buildText(context, false);

                return AnimatedExpandingContainer(
                    expanded: this._expanded,
                    expandedWidget: buildText(context, true),
                    unexpandedWidget: buildText(context, false),
                );
            }
        );
    }

    @override
    Widget build(BuildContext context) {
        return Card(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            child: InkWell(
                autofocus: super.widget.autofocus,
                onFocusChange: (bool focused) {
                    if (focused && EPlatform.isTV)
                        super.widget.onTvFocus?.call();
                },
                onTap: () {
                    super.setState(() => this._expanded = !this._expanded);
                    if(this._expanded)
                        Scrollable.ensureVisible(
                            FocusScope.of(context).focusedChild!.parent!.context!,
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeInOut,
                            alignmentPolicy: ScrollPositionAlignmentPolicy.explicit
                        );
                    else if(EPlatform.isTV)
                        super.widget.onTvFocus?.call();
                },
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: this._buildContent(context)
                )
            )
        );
    }
}
