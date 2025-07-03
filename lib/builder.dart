import 'package:build/build.dart';

import 'src/config/rive_gen_config.dart';
import 'src/generators/generators.dart';
import 'src/utils/utils.dart';

/// Builder function for build_runner integration.
Builder riveGenBuilder(BuilderOptions options) {
  return RiveGenBuilder();
}

/// Main builder class that handles Rive asset code generation.
class RiveGenBuilder implements Builder {
  @override
  final Map<String, List<String>> buildExtensions = const {
    r'$package$': [
      'lib/generated/rive_assets.dart',
      'lib/generated/assets/{{}}.dart',
      'lib/generated/controllers/{{}}.dart',
    ],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    try {
      Logger.step('Starting Rive code generation...');

      // Load configuration
      final config = await RiveGenConfig.load();
      Logger.setDebugMode(config.debugMode);

      Logger.debug('Configuration loaded: $config');

      // Find all Rive files
      final riveFiles = await FileUtils.findRiveFiles(config.assetsPath);
      Logger.info('Found ${riveFiles.length} Rive files');

      if (riveFiles.isEmpty) {
        Logger.warning(
          'No Rive files found matching pattern: ${config.assetsPath}',
        );
        return;
      }

      Logger.logList(LogLevel.debug, 'Rive files:', riveFiles);

      // Parse Rive files and generate code
      final generator = RiveCodeGenerator(config: config);
      await generator.generateAll(riveFiles);

      Logger.success('Rive code generation completed successfully!');
    } catch (e, stackTrace) {
      Logger.error('Failed to generate Rive code', e, stackTrace);
      rethrow;
    }
  }
}

/// Post-process builder for additional cleanup and optimization.
class RiveGenPostProcessBuilder implements PostProcessBuilder {
  @override
  final Set<String> inputExtensions = const {'.dart'};

  @override
  Future<void> build(PostProcessBuildStep buildStep) async {
    // Post-processing logic if needed
    // For example: formatting, optimization, etc.
  }
}

/// Configuration for the builder.
class RiveGenBuilderConfig {
  /// Whether to enable debug mode
  final bool debugMode;

  /// The assets path pattern
  final String assetsPath;

  /// The output directory
  final String outputDir;

  /// Constructor
  const RiveGenBuilderConfig({
    this.debugMode = false,
    this.assetsPath = 'assets/**/*.riv',
    this.outputDir = 'lib/generated',
  });

  /// Create from build options
  factory RiveGenBuilderConfig.fromOptions(BuilderOptions options) {
    final config = options.config;

    return RiveGenBuilderConfig(
      debugMode: config['debug_mode'] as bool? ?? false,
      assetsPath: config['assets_path'] as String? ?? 'assets/**/*.riv',
      outputDir: config['output_dir'] as String? ?? 'lib/generated',
    );
  }
}
