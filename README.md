# progress_loading_button

![GitHub repo size](https://img.shields.io/github/repo-size/gairick-saha/progress_loading_button.svg)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/gairick-saha/progress_loading_button.svg)
![GitHub top language](https://img.shields.io/github/languages/top/gairick-saha/progress_loading_button.svg)
[![GitHub issues](https://img.shields.io/github/issues/gairick-saha/progress_loading_button.svg)](https://github.com/gairick-saha/progress_loading_button/issues)
[![GitHub license](https://img.shields.io/github/license/gairick-saha/progress_loading_button.svg)](https://github.com/gairick-saha/progress_loading_button/blob/master/LICENSE)

**progress_loading_button** is a free and open source (MIT license) Material Flutter Button that supports variety of buttons style demands. It is designed to be easy to use and customizable.

## Get started

Add this to your package's pubspec.yaml file:

```yaml
progress_loading_button: '^1.0.0'
```

### **Install it**

You can install packages from the command line:

```
$ flutter pub get
```

Alternatively, your editor might support flutter pub get.

### **Import it**

Now in your Dart code, you can use:

```dart
import 'package:progress_loading_button/progress_loading_button.dart';

```

## How to use

Add `LoadingButton` to your widget tree:

```dart
LoadingButton(
    defaultWidget: Text('Click Me'),
    width: 196,
    height: 60,
    onPressed: () async {
        await Future.delayed(
            Duration(milliseconds: 3000),
            () {
                print('Button Pressed');
            },
        );
    },
)
```

More parameters:

```dart
LoadingButton({
    Key? key,
    required this.defaultWidget,
    this.loadingWidget = const CircularProgressIndicator(),
    required this.onPressed,
    this.type = LoadingButtonType.Raised,
    this.color,
    this.width = double.infinity,
    this.height = 40.0,
    this.borderRadius = 5.0,
    this.borderSide = BorderSide.none,
    this.animate = true,
  }) : super(key: key);
```

Three types supported:

```dart
enum LoadingButtonType {
  Raised,
  Flat,
  Outline,
}
```

## Example

![](./demo/progress_loading_button.gif)

## Source

Source code and example of this library can be found in git:

```
$ git clone https://github.com/gairick-saha/progress_loading_button.git
```
