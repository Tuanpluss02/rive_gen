import 'package:rive_gen/rive_gen.dart';

/// Example showing how to use rive_gen package.
void main() async {
  print('=== Rive Gen Example ===');
  print('');

  // Example 1: Create a sample configuration
  print('1. Creating sample configuration...');
  await RiveGenConfig.createSampleConfig();
  print('   ✓ Sample rive_gen.yaml created');
  print('');

  // Example 2: Load configuration
  print('2. Loading configuration...');
  final config = await RiveGenConfig.load();
  print('   ✓ Configuration loaded:');
  print('     - Assets path: ${config.assetsPath}');
  print('     - Output directory: ${config.outputDir}');
  print('     - Debug mode: ${config.debugMode}');
  print('');

  // Example 3: Find Rive files
  print('3. Finding Rive files...');
  final riveFiles = await FileUtils.findRiveFiles(config.assetsPath);
  print('   ✓ Found ${riveFiles.length} Rive files:');
  for (final file in riveFiles) {
    print('     - $file');
  }
  print('');

  // Example 4: Naming utilities
  print('4. Naming utilities examples...');
  _demonstrateNamingUtils();
  print('');

  // Example 5: Generate code (if files exist)
  if (riveFiles.isNotEmpty) {
    print('5. Generating code...');
    final generator = RiveCodeGenerator(config: config);
    try {
      await generator.generateAll(riveFiles);
      print('   ✓ Code generation completed!');
    } catch (e) {
      print('   ✗ Code generation failed: $e');
    }
  } else {
    print('5. No Rive files found - skipping code generation');
    print('   To test code generation:');
    print('   - Create a "assets" directory');
    print('   - Add some .riv files to assets/');
    print('   - Run this example again');
  }

  print('');
  print('=== Example completed ===');
  print('');
  print('Next steps:');
  print('1. Add .riv files to your assets/ directory');
  print('2. Run: dart run rive_gen');
  print('3. Use the generated classes in your Flutter app');
}

/// Demonstrate naming utility functions.
void _demonstrateNamingUtils() {
  final examples = [
    'character_walk',
    'jump-animation',
    'idle State',
    'RunFast',
    'super_hero_fly',
  ];

  print('   Input → PascalCase → camelCase → snake_case');
  for (final example in examples) {
    final pascal = NamingUtils.toPascalCase(example);
    final camel = NamingUtils.toCamelCase(example);
    final snake = NamingUtils.toSnakeCase(example);
    print('   "$example" → "$pascal" → "$camel" → "$snake"');
  }
}
