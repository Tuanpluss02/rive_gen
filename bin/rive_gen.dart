#!/usr/bin/env dart

import 'dart:io';

import 'package:args/args.dart';
import 'package:rive_gen/src/config/rive_gen_config.dart';
import 'package:rive_gen/src/generators/rive_code_generator.dart';
import 'package:rive_gen/src/utils/utils.dart';

/// Command line interface for rive_gen.
void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Show this help message.',
      negatable: false,
    )
    ..addFlag('debug', abbr: 'd', help: 'Enable debug mode.', defaultsTo: false)
    ..addFlag(
      'watch',
      abbr: 'w',
      help: 'Watch for file changes and regenerate automatically.',
      defaultsTo: false,
    )
    ..addFlag(
      'create-config',
      help: 'Create a sample rive_gen.yaml configuration file.',
      negatable: false,
    )
    ..addOption(
      'config',
      abbr: 'c',
      help: 'Path to the configuration file.',
      defaultsTo: 'rive_gen.yaml',
    )
    ..addOption(
      'assets-path',
      help: 'Path pattern for Rive assets.',
      defaultsTo: 'assets/**/*.riv',
    )
    ..addOption(
      'output-dir',
      abbr: 'o',
      help: 'Output directory for generated files.',
      defaultsTo: 'lib/generated',
    );

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      _printUsage(parser);
      return;
    }

    if (results['create-config'] as bool) {
      await _createConfig(results['config'] as String);
      return;
    }

    await _generateCode(results);
  } catch (e) {
    print('Error: $e');
    _printUsage(parser);
    exit(1);
  }
}

/// Print usage information.
void _printUsage(ArgParser parser) {
  print('Rive Gen - Code generator for Rive assets');
  print('');
  print('Usage: rive_gen [options]');
  print('');
  print('Options:');
  print(parser.usage);
  print('');
  print('Examples:');
  print('  rive_gen                    # Generate code with default settings');
  print('  rive_gen --debug            # Generate with debug output');
  print('  rive_gen --watch            # Watch for changes and regenerate');
  print('  rive_gen --create-config    # Create sample configuration file');
  print('  rive_gen -c my_config.yaml  # Use custom configuration file');
}

/// Create a sample configuration file.
Future<void> _createConfig(String configPath) async {
  try {
    await RiveGenConfig.createSampleConfig(configPath: configPath);
    Logger.success('Created sample configuration file: $configPath');
    print('');
    print('Edit the configuration file to customize your settings, then run:');
    print('  rive_gen');
  } catch (e) {
    Logger.error('Failed to create configuration file', e);
    exit(1);
  }
}

/// Generate code based on configuration.
Future<void> _generateCode(ArgResults results) async {
  try {
    // Enable debug mode if requested
    final debugMode = results['debug'] as bool;
    Logger.setDebugMode(debugMode);

    Logger.info('Starting Rive code generation...');

    // Load configuration
    final configPath = results['config'] as String;
    RiveGenConfig config;

    try {
      config = await RiveGenConfig.load(configPath: configPath);
    } catch (e) {
      // Use command line arguments as fallback
      config = RiveGenConfig(
        assetsPath: results['assets-path'] as String,
        outputDir: results['output-dir'] as String,
        debugMode: debugMode,
      );

      if (debugMode) {
        Logger.warning(
          'Could not load config file, using command line arguments',
        );
      }
    }

    // Update debug mode from config
    Logger.setDebugMode(config.debugMode || debugMode);

    // Find Rive files
    final riveFiles = await FileUtils.findRiveFiles(config.assetsPath);

    if (riveFiles.isEmpty) {
      Logger.warning(
        'No Rive files found matching pattern: ${config.assetsPath}',
      );
      Logger.info('Make sure your Rive files are in the correct location.');
      Logger.info(
        'You can create a configuration file with: rive_gen --create-config',
      );
      return;
    }

    // Generate code
    final generator = RiveCodeGenerator(config: config);
    await generator.generateAll(riveFiles);

    Logger.success('Code generation completed successfully!');

    // Watch mode
    final watchMode = results['watch'] as bool;
    if (watchMode) {
      Logger.info('Watching for changes... Press Ctrl+C to stop.');
      await _watchFiles(config, riveFiles);
    }
  } catch (e, stackTrace) {
    Logger.error('Code generation failed', e, stackTrace);
    exit(1);
  }
}

/// Watch files for changes and regenerate automatically.
Future<void> _watchFiles(
  RiveGenConfig config,
  List<String> initialFiles,
) async {
  // TODO: Implement file watching
  Logger.warning('Watch mode is not yet implemented');
  Logger.info('This feature will be added in a future version');
}
