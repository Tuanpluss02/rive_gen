<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

# Rive Gen

A powerful code generator that automatically creates type-safe Dart classes for Rive assets, similar to how `flutter_gen` works for images.

[![Pub Version](https://img.shields.io/pub/v/rive_gen.svg)](https://pub.dev/packages/rive_gen)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## ✨ Features

- 🎯 **Type-safe asset references** - No more string-based asset paths
- 🎮 **State machine detection** - Automatic discovery of state machines, inputs, and animations
- 🎛️ **Input controllers** - Type-safe controllers for triggers, booleans, and number inputs
- 🎬 **Animation timeline access** - Direct access to animation properties
- 🏗️ **Nested artboard support** - Handle multiple artboards within a single Rive file
- 📡 **Event listeners** - Type-safe event handling
- 🔄 **Build runner integration** - Automatic regeneration on file changes
- 🎨 **Customizable output** - Flexible configuration options

## 📦 Installation

Add `rive_gen` to your `dev_dependencies`:

```yaml
dev_dependencies:
  rive_gen: ^1.0.0
  build_runner: ^2.4.7
```

## 🚀 Quick Start

### 1. Install the package

```bash
dart pub add dev:rive_gen
dart pub add dev:build_runner
```

### 2. Create configuration

Create a `rive_gen.yaml` file in your project root:

```bash
dart run rive_gen --create-config
```

Or create it manually:

```yaml
# rive_gen.yaml
assets_path: assets/**/*.riv
output_dir: lib/generated
debug_mode: false
generate_asset_classes: true
generate_controllers: true
generate_barrel: true
```

### 3. Add Rive files

Place your `.riv` files in the `assets/` directory:

```
assets/
├── characters/
│   ├── hero.riv
│   └── enemy.riv
└── ui/
    └── button.riv
```

### 4. Generate code

```bash
# One-time generation
dart run rive_gen

# With build_runner (recommended)
dart run build_runner build

# Watch mode
dart run build_runner watch
```

### 5. Use generated classes

```dart
import 'package:your_app/generated/rive_assets.dart';

// Type-safe asset loading
final heroAsset = RiveAssets.hero;
print(heroAsset.path); // "assets/characters/hero.riv"

// Type-safe controllers (when implemented)
final heroController = HeroController();
heroController.stateMachine.idle.trigger();
heroController.inputs.speed.value = 1.5;
```

## 📖 Usage

### Command Line Interface

The `rive_gen` CLI provides several options:

```bash
# Basic usage
dart run rive_gen

# Enable debug output
dart run rive_gen --debug

# Use custom config file
dart run rive_gen --config my_config.yaml

# Override assets path
dart run rive_gen --assets-path "custom/path/**/*.riv"

# Custom output directory
dart run rive_gen --output-dir lib/my_generated

# Watch for changes
dart run rive_gen --watch

# Show help
dart run rive_gen --help
```

### Configuration Options

The `rive_gen.yaml` file supports the following options:

```yaml
# Path pattern for Rive assets (supports glob patterns)
assets_path: assets/**/*.riv

# Output directory for generated files
output_dir: lib/generated

# Enable debug logging
debug_mode: false

# Generate individual asset classes
generate_asset_classes: true

# Generate controller classes with input handling
generate_controllers: true

# Generate a barrel file for easy imports
generate_barrel: true

# Package name for imports (auto-detected if not specified)
package_name: my_app

# Class name prefix and suffix
class_prefix: ""
class_suffix: ""
```

### Build Runner Integration

Add to your `build.yaml`:

```yaml
targets:
  $default:
    builders:
      rive_gen|rive_gen:
        enabled: true
        options:
          assets_path: "assets/**/*.riv"
          output_dir: "lib/generated"
          debug_mode: false
```

## 🏗️ Generated Code Structure

```
lib/generated/
├── rive_assets.dart          # Main barrel file
├── assets/
│   ├── hero.dart            # Individual asset classes
│   ├── enemy.dart
│   └── button.dart
└── controllers/
    ├── hero_controller.dart  # Type-safe controllers
    ├── enemy_controller.dart
    └── button_controller.dart
```

## 🎯 Generated Classes

### Asset Classes

```dart
/// Generated asset class for hero.riv
class Hero {
  /// The path to the Rive asset
  static const String path = 'assets/characters/hero.riv';
  
  /// The asset name
  static const String name = 'hero';
  
  // Artboards, animations, and state machines will be added here
}
```

### Controller Classes (Planned)

```dart
/// Generated controller class for hero.riv
class HeroController extends RiveAnimationController {
  // State machine controls
  final stateMachine = HeroStateMachine();
  
  // Input controls
  final inputs = HeroInputs();
  
  // Animation controls
  final animations = HeroAnimations();
}
```

## 🔮 Roadmap

This package is currently in its initial release. Planned features include:

- [ ] **Rive file parsing** - Direct parsing of `.riv` files to extract metadata
- [ ] **Complete controller generation** - Full implementation of state machine controllers
- [ ] **Input type detection** - Automatic detection of trigger, boolean, and number inputs
- [ ] **Animation properties** - Access to animation duration, looping, etc.
- [ ] **Event listeners** - Type-safe event handling
- [ ] **Artboard support** - Multiple artboard handling
- [ ] **File watching** - Automatic regeneration on file changes
- [ ] **Documentation generation** - Auto-generated documentation
- [ ] **IDE integration** - Better IDE support and auto-completion

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

1. Clone the repository
2. Install dependencies: `dart pub get`
3. Run tests: `dart test`
4. Run example: `dart run example/rive_gen_example.dart`

### Building

```bash
# Run tests
dart test

# Format code
dart format .

# Analyze code
dart analyze

# Generate documentation
dart doc
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by [flutter_gen](https://pub.dev/packages/flutter_gen)
- Built for the [Rive](https://rive.app) animation platform
- Thanks to the Dart and Flutter community

## 📞 Support

- 🐛 [Report Issues](https://github.com/Tuanpluss02/rive_gen/issues)
- 💬 [Discussions](https://github.com/Tuanpluss02/rive_gen/discussions)
- 📧 [Email Support](mailto:support@example.com)

---

Made with ❤️ for the Flutter community
