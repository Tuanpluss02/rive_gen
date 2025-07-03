import 'package:rive_gen/rive_gen.dart';
import 'package:test/test.dart';

void main() {
  group('RiveGenConfig', () {
    test('should create default config', () {
      const config = RiveGenConfig();

      expect(config.assetsPath, equals('assets/**/*.riv'));
      expect(config.outputDir, equals('lib/generated'));
      expect(config.debugMode, isFalse);
      expect(config.generateAssetClasses, isTrue);
      expect(config.generateControllers, isTrue);
      expect(config.generateBarrel, isTrue);
    });

    test('should create custom config', () {
      const config = RiveGenConfig(
        assetsPath: 'custom/**/*.riv',
        outputDir: 'custom/output',
        debugMode: true,
        generateAssetClasses: false,
        generateControllers: false,
        generateBarrel: false,
        classPrefix: 'My',
        classSuffix: 'Asset',
      );

      expect(config.assetsPath, equals('custom/**/*.riv'));
      expect(config.outputDir, equals('custom/output'));
      expect(config.debugMode, isTrue);
      expect(config.generateAssetClasses, isFalse);
      expect(config.generateControllers, isFalse);
      expect(config.generateBarrel, isFalse);
      expect(config.classPrefix, equals('My'));
      expect(config.classSuffix, equals('Asset'));
    });
  });

  group('NamingUtils', () {
    test('should convert to PascalCase', () {
      expect(NamingUtils.toPascalCase('hello_world'), equals('HelloWorld'));
      expect(
        NamingUtils.toPascalCase('jump-animation'),
        equals('JumpAnimation'),
      );
      expect(NamingUtils.toPascalCase('idle State'), equals('IdleState'));
      expect(NamingUtils.toPascalCase('RunFast'), equals('Runfast'));
    });

    test('should convert to camelCase', () {
      expect(NamingUtils.toCamelCase('hello_world'), equals('helloWorld'));
      expect(
        NamingUtils.toCamelCase('jump-animation'),
        equals('jumpAnimation'),
      );
      expect(NamingUtils.toCamelCase('idle State'), equals('idleState'));
      expect(NamingUtils.toCamelCase('RunFast'), equals('runfast'));
    });

    test('should convert to snake_case', () {
      expect(NamingUtils.toSnakeCase('HelloWorld'), equals('hello_world'));
      expect(
        NamingUtils.toSnakeCase('jumpAnimation'),
        equals('jump_animation'),
      );
      expect(NamingUtils.toSnakeCase('IdleState'), equals('idle_state'));
    });

    test('should convert to kebab-case', () {
      expect(NamingUtils.toKebabCase('HelloWorld'), equals('hello-world'));
      expect(
        NamingUtils.toKebabCase('jumpAnimation'),
        equals('jump-animation'),
      );
      expect(NamingUtils.toKebabCase('IdleState'), equals('idle-state'));
    });

    test('should sanitize identifiers', () {
      expect(
        NamingUtils.sanitizeIdentifier('hello world'),
        equals('hello_world'),
      );
      expect(
        NamingUtils.sanitizeIdentifier('123invalid'),
        equals('_123invalid'),
      );
      expect(
        NamingUtils.sanitizeIdentifier('valid-name'),
        equals('valid_name'),
      );
      expect(NamingUtils.sanitizeIdentifier(''), equals('unnamed'));
    });

    test('should generate class names', () {
      expect(
        NamingUtils.generateClassName('hello_world'),
        equals('HelloWorld'),
      );
      expect(
        NamingUtils.generateClassName('hello_world', prefix: 'My'),
        equals('MyHelloWorld'),
      );
      expect(
        NamingUtils.generateClassName('hello_world', suffix: 'Asset'),
        equals('HelloWorldAsset'),
      );
    });

    test('should generate property names', () {
      expect(
        NamingUtils.generatePropertyName('hello_world'),
        equals('helloWorld'),
      );
      expect(
        NamingUtils.generatePropertyName('jump-animation'),
        equals('jumpAnimation'),
      );
    });

    test('should generate file names', () {
      expect(
        NamingUtils.generateFileName('HelloWorld'),
        equals('hello_world.dart'),
      );
      expect(
        NamingUtils.generateFileName('jumpAnimation'),
        equals('jump_animation.dart'),
      );
    });

    test('should validate Dart identifiers', () {
      expect(NamingUtils.isValidDartIdentifier('validName'), isTrue);
      expect(NamingUtils.isValidDartIdentifier('_validName'), isTrue);
      expect(NamingUtils.isValidDartIdentifier('123invalid'), isFalse);
      expect(NamingUtils.isValidDartIdentifier('class'), isFalse); // keyword
      expect(NamingUtils.isValidDartIdentifier(''), isFalse);
    });

    test('should validate Dart class names', () {
      expect(NamingUtils.isValidDartClassName('ValidClassName'), isTrue);
      expect(
        NamingUtils.isValidDartClassName('_ValidClassName'),
        isFalse,
      ); // private
      expect(
        NamingUtils.isValidDartClassName('invalidClassName'),
        isFalse,
      ); // lowercase
      expect(NamingUtils.isValidDartClassName('123Invalid'), isFalse);
    });
  });

  group('RiveAsset', () {
    test('should create from path', () {
      final asset = RiveAsset.fromPath('assets/characters/hero.riv');

      expect(asset.path, equals('assets/characters/hero.riv'));
      expect(asset.name, equals('hero'));
      expect(asset.className, equals('Hero'));
    });

    test('should handle complex file names', () {
      final asset = RiveAsset.fromPath('assets/ui/jump_button.riv');

      expect(asset.name, equals('jump_button'));
      expect(asset.className, equals('JumpButton'));
    });

    test('should have equality', () {
      final asset1 = RiveAsset.fromPath('assets/hero.riv');
      final asset2 = RiveAsset.fromPath('assets/hero.riv');
      final asset3 = RiveAsset.fromPath('assets/enemy.riv');

      expect(asset1, equals(asset2));
      expect(asset1, isNot(equals(asset3)));
    });
  });

  group('RiveAnimation', () {
    test('should calculate total frames', () {
      const animation = RiveAnimation(
        name: 'walk',
        propertyName: 'walk',
        duration: 2.0,
        fps: 30.0,
      );

      expect(animation.totalFrames, equals(60));
    });

    test('should handle work area', () {
      const animation = RiveAnimation(
        name: 'walk',
        propertyName: 'walk',
        duration: 2.0,
        fps: 30.0,
        workAreaStart: 0.5,
        workAreaEnd: 1.5,
      );

      expect(animation.effectiveStartTime, equals(0.5));
      expect(animation.effectiveEndTime, equals(1.5));
      expect(animation.effectiveDuration, equals(1.0));
    });
  });

  group('RiveInput', () {
    test('should create trigger input', () {
      const input = RiveTriggerInput(name: 'jump', propertyName: 'jump');

      expect(input.type, equals(RiveInputType.trigger));
      expect(input.name, equals('jump'));
    });

    test('should create boolean input', () {
      const input = RiveBooleanInput(
        name: 'isRunning',
        propertyName: 'isRunning',
        initialValue: true,
      );

      expect(input.type, equals(RiveInputType.boolean));
      expect(input.initialValue, isTrue);
    });

    test('should create number input', () {
      const input = RiveNumberInput(
        name: 'speed',
        propertyName: 'speed',
        initialValue: 1.5,
        minValue: 0.0,
        maxValue: 10.0,
      );

      expect(input.type, equals(RiveInputType.number));
      expect(input.initialValue, equals(1.5));
      expect(input.minValue, equals(0.0));
      expect(input.maxValue, equals(10.0));
    });
  });

  group('FileUtils', () {
    test('should extract base directory from pattern', () {
      // This tests the private method indirectly through pattern matching
      expect(
        FileUtils.findRiveFiles('assets/**/*.riv'),
        completion(isA<List<String>>()),
      );
    });
  });
}
