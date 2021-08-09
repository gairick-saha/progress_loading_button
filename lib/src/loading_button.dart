import 'package:flutter/material.dart';

enum LoadingButtonState {
  Default,
  Processing,
}

enum LoadingButtonType {
  Raised,
  Flat,
  Outline,
}

class LoadingButton extends StatefulWidget {
  final Widget defaultWidget;
  final Widget? loadingWidget;
  final Function onPressed;
  final LoadingButtonType? type;
  final Color? color;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BorderSide? borderSide;
  final bool? animate;

  LoadingButton({
    Key? key,
    required this.defaultWidget,
    this.loadingWidget = const CircularProgressIndicator(),
    required this.onPressed,
    this.type = LoadingButtonType.Raised,
    this.color = Colors.transparent,
    this.width = double.infinity,
    this.height = 40.0,
    this.borderRadius = 5.0,
    this.borderSide = BorderSide.none,
    this.animate = true,
  }) : super(key: key);

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton>
    with TickerProviderStateMixin {
  GlobalKey _globalKey = GlobalKey();
  Animation? _anim;
  AnimationController? _animController;
  Duration _duration = const Duration(milliseconds: 250);
  LoadingButtonState? _state;
  double? _width;
  double? _height;
  double? _borderRadius;
  BorderSide? _borderSide;

  @override
  dispose() {
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
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_borderRadius!),
      child: SizedBox(
        key: _globalKey,
        height: _height,
        width: _width,
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    final ButtonStyle _textbuttonStyle = TextButton.styleFrom(
      primary: widget.color,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius!),
        side: _borderSide!,
      ),
    );
    final ButtonStyle _elevatedbuttonStyle = ElevatedButton.styleFrom(
      primary: widget.color,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius!),
        side: _borderSide!,
      ),
    );
    final ButtonStyle _outlinedbuttonStyle = OutlinedButton.styleFrom(
      primary: widget.color,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius!),
        side: _borderSide!,
      ),
    );

    switch (widget.type!) {
      case LoadingButtonType.Raised:
        return ElevatedButton(
          style: _elevatedbuttonStyle,
          child: _buildChildren(context),
          onPressed: _onButtonPressed(),
        );
      case LoadingButtonType.Flat:
        return TextButton(
          style: _textbuttonStyle,
          child: _buildChildren(context),
          onPressed: _onButtonPressed(),
        );
      case LoadingButtonType.Outline:
        return OutlinedButton(
          style: _outlinedbuttonStyle,
          child: _buildChildren(context),
          onPressed: _onButtonPressed(),
        );
    }
  }

  Widget _buildChildren(BuildContext context) {
    Widget ret;
    switch (_state!) {
      case LoadingButtonState.Default:
        ret = widget.defaultWidget;
        break;
      case LoadingButtonState.Processing:
        ret = widget.loadingWidget ?? widget.defaultWidget;
        break;
    }
    return ret;
  }

  VoidCallback _onButtonPressed() {
    return () async {
      if (_state != LoadingButtonState.Default) {
        return;
      }

      VoidCallback? onDefault;
      if (widget.animate!) {
        _toProcessing();
        _forward((status) {
          if (status == AnimationStatus.dismissed) {
            _toDefault();
            if (onDefault != null && onDefault is VoidCallback) {
              onDefault();
            }
          }
        });
        onDefault = await widget.onPressed();
        _reverse();
      } else {
        _toProcessing();
        onDefault = await widget.onPressed();
        _toDefault();
        if (onDefault != null && onDefault is VoidCallback) {
          onDefault();
        }
      }
    };
  }

  void _toProcessing() {
    setState(() {
      _state = LoadingButtonState.Processing;
    });
  }

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
