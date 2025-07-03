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
      await _watchFiles(
        configPath,
        config.assetsPath,
        config.outputDir,
        config.debugMode,
      );
    }
  } catch (e, stackTrace) {
    Logger.error('Code generation failed', e, stackTrace);
    exit(1);
  }
}

/// Watch for file changes and regenerate code
Future<void> _watchFiles(
  String configPath,
  String? assetsPath,
  String? outputDir,
  bool debugMode,
) async {
  print('');
  Logger.info('File watching is not yet implemented');
  Logger.warning('This feature will be added in a future release');
  print('\nPlanning to watch:');
  print('  • Configuration file: $configPath');
  if (assetsPath != null) {
    print('  • Assets directory: $assetsPath');
  }
  if (outputDir != null) {
    print('  • Output directory: $outputDir');
  }

  print('');
  Logger.info('For now, you can run the generator manually when files change:');
  print(
    '  dart run rive_gen ${debugMode ? '--debug ' : ''}${configPath != 'rive_gen.yaml' ? '--config=$configPath ' : ''}${assetsPath != null ? '--assets-path=$assetsPath ' : ''}${outputDir != null ? '--output-dir=$outputDir' : ''}',
  );

  // TODO: Implement proper file watching using package:watcher
  // This would involve:
  // 1. Creating a DirectoryWatcher for the assets directory
  // 2. Creating a FileWatcher for the config file
  // 3. Debouncing file change events to avoid rapid regeneration
  // 4. Automatically running the generator when changes are detected

  /*
  Future implementation outline:
  
  import 'package:watcher/watcher.dart';
  
  final configWatcher = FileWatcher(configPath);
  final assetsWatcher = DirectoryWatcher(assetsDirectory);
  
  // Debounce mechanism to avoid rapid regeneration
  Timer? debounceTimer;
  
  void scheduleRegeneration() {
    debounceTimer?.cancel();
    debounceTimer = Timer(Duration(milliseconds: 500), () async {
      try {
        print('Files changed, regenerating...');
        await _runGeneration(configPath, assetsPath, outputDir, debugMode);
        print('✅ Regeneration complete');
      } catch (e) {
        print('❌ Regeneration failed: $e');
      }
    });
  }
  
  configWatcher.events.listen((event) {
    print('Config file changed: ${event.path}');
    scheduleRegeneration();
  });
  
  assetsWatcher.events.listen((event) {
    if (event.path.endsWith('.riv')) {
      print('Rive file changed: ${event.path}');
      scheduleRegeneration();
    }
  });
  
  print('👀 Watching for changes... Press Ctrl+C to stop');
  
  // Keep the process alive
  await Completer<void>().future;
  */
}
