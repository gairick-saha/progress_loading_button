import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum LoadingButtonState {
  Default,
  Processing,
}

enum LoadingButtonType {
  Elevated,
  Text,
  Outline,
}

class LoadingButton extends StatefulWidget {
  const LoadingButton({
    Key? key,
    required this.defaultWidget,
    this.loadingWidget,
    required this.onPressed,
    this.type = LoadingButtonType.Elevated,
    this.color,
    this.textcolor,
    this.width,
    this.height = kMinInteractiveDimension,
    this.borderRadius = 5.0,
    this.borderSide = BorderSide.none,
    this.animate = true,
    this.padding,
  }) : super(key: key);

  final Widget defaultWidget;
  final Widget? loadingWidget;
  final Function? onPressed;
  final LoadingButtonType? type;
  final Color? color;
  final Color? textcolor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BorderSide? borderSide;
  final bool animate;
  final EdgeInsetsGeometry? padding;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton>
    with TickerProviderStateMixin {
  final GlobalKey _globalKey = GlobalKey();
  Animation? _anim;
  AnimationController? _animController;
  final Duration _duration = const Duration(milliseconds: 250);
  LoadingButtonState? _state;
  double? _width;
  double? _height;
  double? _borderRadius;
  BorderSide? _borderSide;

  @override
  void dispose() {
    _animController?.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _reset();
    super.deactivate();
  }

  @override
  void initState() {
    _reset();
    super.initState();
  }

  void _reset() {
    _state = LoadingButtonState.Default;
    _width = widget.width;
    _height = widget.height;
    _borderRadius = widget.borderRadius;
    _borderSide = widget.borderSide;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _globalKey,
      height: _height,
      width: _width,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    final ButtonStyle textbuttonStyle = TextButton.styleFrom(
      foregroundColor: widget.textcolor,
      disabledForegroundColor: widget.textcolor,
      padding: _state == LoadingButtonState.Processing
          ? EdgeInsets.zero
          : widget.padding ??
              ButtonStyleButton.scaledPadding(
                const EdgeInsets.symmetric(horizontal: 16),
                const EdgeInsets.symmetric(horizontal: 8),
                const EdgeInsets.symmetric(horizontal: 4),
                MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
              ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius!),
        side: _borderSide!,
      ),
      splashFactory: NoSplash.splashFactory,
      alignment: Alignment.center,
    );
    final ButtonStyle elevatedbuttonStyle = ElevatedButton.styleFrom(
      backgroundColor: widget.color,
      disabledBackgroundColor:
          widget.color ?? Theme.of(context).colorScheme.primary,
      foregroundColor: widget.textcolor,
      disabledForegroundColor:
          widget.textcolor ?? Theme.of(context).colorScheme.surface,
      elevation: _state! == LoadingButtonState.Processing ? 0 : null,
      padding: _state == LoadingButtonState.Processing
          ? EdgeInsets.zero
          : widget.padding ??
              ButtonStyleButton.scaledPadding(
                const EdgeInsets.symmetric(horizontal: 16),
                const EdgeInsets.symmetric(horizontal: 8),
                const EdgeInsets.symmetric(horizontal: 4),
                MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
              ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius!),
        side: _borderSide!,
      ),
      splashFactory: NoSplash.splashFactory,
      alignment: Alignment.center,
    );
    final ButtonStyle outlinedbuttonStyle = OutlinedButton.styleFrom(
      side: BorderSide(
        color: widget.color ?? Theme.of(context).colorScheme.primary,
      ),
      foregroundColor: widget.textcolor ?? widget.color,
      disabledForegroundColor: widget.textcolor ?? widget.color,
      padding: _state == LoadingButtonState.Processing
          ? EdgeInsets.zero
          : widget.padding ??
              ButtonStyleButton.scaledPadding(
                const EdgeInsets.symmetric(horizontal: 16),
                const EdgeInsets.symmetric(horizontal: 8),
                const EdgeInsets.symmetric(horizontal: 4),
                MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
              ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius!),
        side: _borderSide!,
      ),
      splashFactory: NoSplash.splashFactory,
      alignment: Alignment.center,
    );

    switch (widget.type!) {
      case LoadingButtonType.Elevated:
        return ElevatedButton(
          style: elevatedbuttonStyle,
          onPressed: _onButtonPressed(),
          child: _buildButtonChild(
            context,
            loadingColor:
                widget.textcolor ?? Theme.of(context).colorScheme.surface,
          ),
        );
      case LoadingButtonType.Text:
        return TextButton(
          style: textbuttonStyle,
          onPressed: _onButtonPressed(),
          child: _buildButtonChild(
            context,
            loadingColor: widget.color ?? Theme.of(context).colorScheme.primary,
          ),
        );
      case LoadingButtonType.Outline:
        return OutlinedButton(
          style: outlinedbuttonStyle,
          onPressed: _onButtonPressed(),
          child: _buildButtonChild(
            context,
            loadingColor: widget.color ?? Theme.of(context).colorScheme.primary,
          ),
        );
    }
  }

  Widget _buildButtonChild(BuildContext context,
      {required Color loadingColor}) {
    Widget buttonWidget;
    switch (_state!) {
      case LoadingButtonState.Default:
        buttonWidget = widget.defaultWidget;
        break;
      case LoadingButtonState.Processing:
        buttonWidget = _buildLoadingIndicator(context, color: loadingColor);
        break;
    }
    return buttonWidget;
  }

  Widget _buildLoadingIndicator(BuildContext context, {required Color color}) {
    return widget.loadingWidget ??
        (!kIsWeb && Platform.isIOS
            ? CupertinoActivityIndicator(
                color: color,
              )
            : CircularProgressIndicator(
                color: color,
                backgroundColor: Colors.transparent,
              ));
  }

  VoidCallback? _onButtonPressed() {
    return _state == LoadingButtonState.Processing
        ? null
        : () async {
            if (_state != LoadingButtonState.Default) {
              return;
            }

            VoidCallback? onDefault;
            if (widget.animate) {
              _toProcessing();
              _forward((status) {
                if (status == AnimationStatus.dismissed) {
                  _toDefault();
                  if (onDefault != null) {
                    onDefault();
                  }
                }
              });
              onDefault =
                  widget.onPressed == null ? null : await widget.onPressed!();
              _reverse();
            } else {
              _toProcessing();
              onDefault =
                  widget.onPressed == null ? null : await widget.onPressed!();
              _toDefault();
              if (onDefault != null) {
                onDefault();
              }
            }
          };
  }

  void _toProcessing() => setState(() {
        _state = LoadingButtonState.Processing;
      });

  void _toDefault() {
    if (mounted) {
      setState(() {
        _state = LoadingButtonState.Default;
      });
    } else {
      _state = LoadingButtonState.Default;
    }
  }

  void _forward(AnimationStatusListener stateListener) {
    double initialWidth = _globalKey.currentContext!.size!.width;
    double initialBorderRadius = widget.borderRadius!;
    double targetWidth = _height!;
    double targetBorderRadius = _height! / 2;

    _animController = AnimationController(duration: _duration, vsync: this);
    _anim = Tween(begin: 0.0, end: 1.0).animate(_animController!)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - targetWidth) * _anim!.value);
          _borderRadius = initialBorderRadius -
              ((initialBorderRadius - targetBorderRadius) * _anim!.value);
        });
      })
      ..addStatusListener(stateListener);

    _animController?.forward();
  }

  void _reverse() {
    _animController?.reverse();
  }
}
