import 'package:path/path.dart' as path;

import '../config/rive_gen_config.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'asset_class_generator.dart';
import 'constants_generator.dart';
import 'controller_generator.dart';

/// Main code generator that orchestrates all Rive code generation.
class RiveCodeGenerator {
  /// The configuration for code generation
  final RiveGenConfig config;

  /// All parsed Rive assets
  final List<RiveAsset> _assets = [];

  /// Constructor
  RiveCodeGenerator({required this.config});

  /// Generate code for all Rive files
  Future<void> generateAll(List<String> riveFilePaths) async {
    Logger.step('Parsing Rive files...');

    // Parse all Rive files
    for (int i = 0; i < riveFilePaths.length; i++) {
      final filePath = riveFilePaths[i];
      Logger.progress('Parsing', i + 1, riveFilePaths.length);

      try {
        final asset = await _parseRiveFile(filePath);
        _assets.add(asset);
        Logger.debug('Parsed: ${asset.name}');
      } catch (e) {
        Logger.error('Failed to parse $filePath', e);
        continue;
      }
    }

    Logger.info('Successfully parsed ${_assets.length} Rive files');

    if (_assets.isEmpty) {
      Logger.warning('No valid Rive files to process');
      return;
    }

    // Ensure output directories exist
    await _ensureOutputDirectories();

    // Generate code
    await _generateAssetClasses();
    await _generateControllers();
    await _generateConstants();
    await _generateBarrelFile();

    Logger.success('Generated code for ${_assets.length} Rive assets');
  }

  /// Parse a single Rive file
  Future<RiveAsset> _parseRiveFile(String filePath) async {
    // For now, create a basic asset from file path
    // TODO: Implement actual Rive file parsing
    final asset = RiveAsset.fromPath(filePath);

    // Create mock artboard for demonstration
    final artboard = RiveArtboard(
      name: 'Main',
      className: '${asset.className}Artboard',
      stateMachines: [],
      animations: [],
      isDefault: true,
    );

    return RiveAsset(
      path: asset.path,
      name: asset.name,
      className: asset.className,
      artboards: [artboard],
    );
  }

  /// Ensure all output directories exist
  Future<void> _ensureOutputDirectories() async {
    await FileUtils.ensureDirectoryExists(config.getOutputPath());

    if (config.generateAssetClasses) {
      await FileUtils.ensureDirectoryExists(config.assetsOutputPath);
    }

    if (config.generateControllers) {
      await FileUtils.ensureDirectoryExists(config.controllersOutputPath);
    }
  }

  /// Generate asset classes
  Future<void> _generateAssetClasses() async {
    if (!config.generateAssetClasses) return;

    Logger.step('Generating asset classes...');

    for (int i = 0; i < _assets.length; i++) {
      final asset = _assets[i];
      Logger.progress('Generating asset classes', i + 1, _assets.length);

      final generator = AssetClassGenerator(asset: asset, config: config);
      final code = generator.generate();

      final fileName = NamingUtils.generateFileName(asset.name);
      final filePath = path.join(config.assetsOutputPath, fileName);

      await FileUtils.writeFile(filePath, code);
    }
  }

  /// Generate controller classes
  Future<void> _generateControllers() async {
    if (!config.generateControllers) return;

    Logger.step('Generating controller classes...');

    for (int i = 0; i < _assets.length; i++) {
      final asset = _assets[i];
      Logger.progress('Generating controllers', i + 1, _assets.length);

      final generator = ControllerGenerator(asset: asset, config: config);
      final code = generator.generate();

      final fileName = NamingUtils.generateFileName('${asset.name}_controller');
      final filePath = path.join(config.controllersOutputPath, fileName);

      await FileUtils.writeFile(filePath, code);
    }
  }

  /// Generate constants file
  Future<void> _generateConstants() async {
    Logger.step('Generating constants file...');

    final generator = ConstantsGenerator(assets: _assets, config: config);
    final code = generator.generate();

    final filePath = path.join(config.getOutputPath(), 'constants.dart');
    await FileUtils.writeFile(filePath, code);
  }

  /// Generate barrel file
  Future<void> _generateBarrelFile() async {
    if (!config.generateBarrel) return;

    Logger.step('Generating barrel file...');

    final generator = BarrelFileGenerator(assets: _assets, config: config);
    final code = generator.generate();

    await FileUtils.writeFile(config.barrelFilePath, code);
  }
}

/// Generator for barrel file
class BarrelFileGenerator {
  final List<RiveAsset> assets;
  final RiveGenConfig config;

  const BarrelFileGenerator({required this.assets, required this.config});

  String generate() {
    final exports = <String>[];

    // Export asset classes
    if (config.generateAssetClasses) {
      for (final asset in assets) {
        final fileName = NamingUtils.generateFileName(asset.name);
        exports.add("export 'assets/$fileName';");
      }
    }

    // Export controllers
    if (config.generateControllers) {
      for (final asset in assets) {
        final fileName = NamingUtils.generateFileName(
          '${asset.name}_controller',
        );
        exports.add("export 'controllers/$fileName';");
      }
    }

    return '''
/// Generated Rive assets
/// 
/// This file is automatically generated. Do not edit manually.
library rive_assets;

export 'constants.dart';
${exports.join('\n')}

/// Main Rive assets class
class RiveAssets {
${assets.map((asset) {
      final className = config.classPrefix + asset.className + config.classSuffix;
      final propertyName = NamingUtils.generatePropertyName(asset.name);
      return "  /// ${asset.name}.riv asset\\n  static const $className $propertyName = $className._();";
    }).join('\n\n')}
}
''';
  }
}
