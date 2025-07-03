/// Utilities for naming conventions and string transformations.
class NamingUtils {
  /// Convert a string to PascalCase (e.g., "hello_world" -> "HelloWorld")
  static String toPascalCase(String input) {
    if (input.isEmpty) return input;

    return input
        .split(RegExp(r'[_\-\s]+'))
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join('');
  }

  /// Convert a string to camelCase (e.g., "hello_world" -> "helloWorld")
  static String toCamelCase(String input) {
    if (input.isEmpty) return input;

    final pascalCase = toPascalCase(input);
    if (pascalCase.isEmpty) return pascalCase;

    return pascalCase[0].toLowerCase() + pascalCase.substring(1);
  }

  /// Convert a string to snake_case (e.g., "HelloWorld" -> "hello_world")
  static String toSnakeCase(String input) {
    if (input.isEmpty) return input;

    return input
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)}_${match.group(2)}',
        )
        .toLowerCase();
  }

  /// Convert a string to kebab-case (e.g., "HelloWorld" -> "hello-world")
  static String toKebabCase(String input) {
    return toSnakeCase(input).replaceAll('_', '-');
  }

  /// Sanitize a string to be a valid Dart identifier
  static String sanitizeIdentifier(String input) {
    if (input.isEmpty) return 'unnamed';

    // Remove invalid characters and replace with underscore
    String sanitized = input.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');

    // Ensure it doesn't start with a number
    if (RegExp(r'^[0-9]').hasMatch(sanitized)) {
      sanitized = '_$sanitized';
    }

    // Ensure it's not empty after sanitization
    if (sanitized.isEmpty || sanitized == '_') {
      sanitized = 'unnamed';
    }

    return sanitized;
  }

  /// Generate a valid Dart class name from input
  static String generateClassName(
    String input, {
    String prefix = '',
    String suffix = '',
  }) {
    final sanitized = sanitizeIdentifier(input);
    final pascalCase = toPascalCase(sanitized);
    return '$prefix$pascalCase$suffix';
  }

  /// Generate a valid Dart property name from input
  static String generatePropertyName(String input) {
    final sanitized = sanitizeIdentifier(input);
    return toCamelCase(sanitized);
  }

  /// Generate a valid Dart file name from input
  static String generateFileName(String input) {
    final sanitized = sanitizeIdentifier(input);
    return '${toSnakeCase(sanitized)}.dart';
  }

  /// Check if a string is a valid Dart identifier
  static bool isValidDartIdentifier(String input) {
    if (input.isEmpty) return false;

    // Check if it matches Dart identifier pattern
    final pattern = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
    if (!pattern.hasMatch(input)) return false;

    // Check if it's not a Dart keyword
    return !_dartKeywords.contains(input);
  }

  /// Check if a string is a valid Dart class name
  static bool isValidDartClassName(String input) {
    if (!isValidDartIdentifier(input)) return false;

    // Class names should start with uppercase
    return input.isNotEmpty && input[0].toUpperCase() == input[0];
  }

  /// Dart keywords that cannot be used as identifiers
  static const Set<String> _dartKeywords = {
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'covariant',
    'default',
    'deferred',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'extends',
    'extension',
    'external',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'function',
    'get',
    'hide',
    'if',
    'implements',
    'import',
    'in',
    'interface',
    'is',
    'late',
    'library',
    'mixin',
    'new',
    'null',
    'on',
    'operator',
    'part',
    'required',
    'rethrow',
    'return',
    'set',
    'show',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'var',
    'void',
    'while',
    'with',
    'yield',
  };
}
