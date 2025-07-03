import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

/// Configuration class for rive_gen package.
class RiveGenConfig {
  /// The path pattern for Rive assets (supports glob patterns)
  final String assetsPath;

  /// The output directory for generated files
  final String outputDir;

  /// Whether to enable debug logging
  final bool debugMode;

  /// Whether to generate individual asset classes
  final bool generateAssetClasses;

  /// Whether to generate controller classes
  final bool generateControllers;

  /// Whether to generate a barrel file
  final bool generateBarrel;

  /// The package name to use in generated imports
  final String? packageName;

  /// The class name prefix for generated classes
  final String classPrefix;

  /// The class name suffix for generated classes
  final String classSuffix;

  /// Default constructor
  const RiveGenConfig({
    this.assetsPath = 'assets/**/*.riv',
    this.outputDir = 'lib/generated',
    this.debugMode = false,
    this.generateAssetClasses = true,
    this.generateControllers = true,
    this.generateBarrel = true,
    this.packageName,
    this.classPrefix = '',
    this.classSuffix = '',
  });

  /// Load configuration from rive_gen.yaml file
  static Future<RiveGenConfig> load({String? configPath}) async {
    configPath ??= 'rive_gen.yaml';

    try {
      final file = File(configPath);
      if (!await file.exists()) {
        return const RiveGenConfig(); // Return default config
      }

      final content = await file.readAsString();
      final yamlDoc = loadYaml(content);

      if (yamlDoc == null) {
        return const RiveGenConfig();
      }

      // Convert YamlMap to Map<String, dynamic>
      final yaml = Map<String, dynamic>.from(yamlDoc as Map);

      return RiveGenConfig(
        assetsPath: yaml['assets_path'] ?? 'assets/**/*.riv',
        outputDir: yaml['output_dir'] ?? 'lib/generated',
        debugMode: yaml['debug_mode'] ?? false,
        generateAssetClasses: yaml['generate_asset_classes'] ?? true,
        generateControllers: yaml['generate_controllers'] ?? true,
        generateBarrel: yaml['generate_barrel'] ?? true,
        packageName: yaml['package_name'],
        classPrefix: yaml['class_prefix'] ?? '',
        classSuffix: yaml['class_suffix'] ?? '',
      );
    } catch (e) {
      throw Exception('Failed to load rive_gen configuration: $e');
    }
  }

  /// Get the absolute path for the output directory
  String getOutputPath() {
    if (path.isAbsolute(outputDir)) {
      return outputDir;
    }
    return path.join(Directory.current.path, outputDir);
  }

  /// Get the path for generated assets
  String get assetsOutputPath => path.join(getOutputPath(), 'assets');

  /// Get the path for generated controllers
  String get controllersOutputPath => path.join(getOutputPath(), 'controllers');

  /// Get the path for the main barrel file
  String get barrelFilePath => path.join(getOutputPath(), 'rive_assets.dart');

  /// Create a sample configuration file
  static Future<void> createSampleConfig({String? configPath}) async {
    configPath ??= 'rive_gen.yaml';

    const sampleConfig = '''
# Rive Gen Configuration
# For more information, see: https://github.com/Tuanpluss02/rive_gen

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
# package_name: my_app

# Class name prefix and suffix
class_prefix: ""
class_suffix: ""
''';

    final file = File(configPath);
    await file.writeAsString(sampleConfig);
  }

  @override
  String toString() =>
      'RiveGenConfig(assetsPath: $assetsPath, outputDir: $outputDir)';
}
