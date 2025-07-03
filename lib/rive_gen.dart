/// A code generator that automatically creates type-safe Dart classes for Rive assets.
///
/// This package provides build_runner integration to automatically generate
/// Dart classes from your Rive files, similar to how flutter_gen works for images.
///
/// Features:
/// - Type-safe asset references
/// - Automatic state machine detection
/// - Input controllers (triggers, booleans, numbers)
/// - Animation timeline access
/// - Nested artboard support
/// - Event listeners
library;

export 'src/config/rive_gen_config.dart';
export 'src/models/models.dart';
export 'src/utils/utils.dart';
