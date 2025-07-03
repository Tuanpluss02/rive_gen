import 'dart:io';

/// Log levels for the logger.
enum LogLevel {
  /// Debug level - most verbose
  debug,

  /// Info level - general information
  info,

  /// Warning level - potentially problematic situations
  warning,

  /// Error level - error events
  error,
}

/// Simple logger for the rive_gen package.
class Logger {
  /// Whether debug mode is enabled
  static bool _debugMode = false;

  /// The minimum log level to output
  static LogLevel _minLevel = LogLevel.info;

  /// Enable or disable debug mode
  static void setDebugMode(bool enabled) {
    _debugMode = enabled;
    _minLevel = enabled ? LogLevel.debug : LogLevel.info;
  }

  /// Set the minimum log level
  static void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  /// Log a debug message
  static void debug(String message) {
    _log(LogLevel.debug, message);
  }

  /// Log an info message
  static void info(String message) {
    _log(LogLevel.info, message);
  }

  /// Log a warning message
  static void warning(String message) {
    _log(LogLevel.warning, message);
  }

  /// Log an error message
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message);
    if (error != null) {
      _log(LogLevel.error, 'Error: $error');
    }
    if (stackTrace != null && _debugMode) {
      _log(LogLevel.error, 'Stack trace:\n$stackTrace');
    }
  }

  /// Log success message (in green if terminal supports colors)
  static void success(String message) {
    if (_shouldLog(LogLevel.info)) {
      final coloredMessage = _supportsColor()
          ? '\x1b[32m✓ $message\x1b[0m'
          : '✓ $message';
      print(coloredMessage);
    }
  }

  /// Log a step in the generation process
  static void step(String message) {
    if (_shouldLog(LogLevel.info)) {
      final coloredMessage = _supportsColor()
          ? '\x1b[36m→ $message\x1b[0m'
          : '→ $message';
      print(coloredMessage);
    }
  }

  /// Internal logging method
  static void _log(LogLevel level, String message) {
    if (!_shouldLog(level)) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase().padRight(7);
    final prefix = _debugMode
        ? '[$timestamp] $levelStr'
        : _getLevelPrefix(level);

    final output = '$prefix $message';

    if (level == LogLevel.error) {
      stderr.writeln(output);
    } else {
      print(output);
    }
  }

  /// Check if a log level should be output
  static bool _shouldLog(LogLevel level) {
    return level.index >= _minLevel.index;
  }

  /// Get a simple prefix for the log level
  static String _getLevelPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '[DEBUG]';
      case LogLevel.info:
        return '[INFO] ';
      case LogLevel.warning:
        return '[WARN] ';
      case LogLevel.error:
        return '[ERROR]';
    }
  }

  /// Check if the terminal supports ANSI color codes
  static bool _supportsColor() {
    return stdout.supportsAnsiEscapes;
  }

  /// Log multiple lines with indentation
  static void logMultiline(LogLevel level, String title, List<String> lines) {
    _log(level, title);
    for (final line in lines) {
      _log(level, '  $line');
    }
  }

  /// Log a list of items
  static void logList(LogLevel level, String title, List<String> items) {
    _log(level, title);
    for (final item in items) {
      _log(level, '  • $item');
    }
  }

  /// Log progress with a percentage
  static void progress(String message, int current, int total) {
    if (!_shouldLog(LogLevel.info)) return;

    final percentage = ((current / total) * 100).round();
    final progressBar = _createProgressBar(percentage);
    final output = '\r$progressBar $message ($current/$total)';

    stdout.write(output);
    if (current == total) {
      print(''); // New line when complete
    }
  }

  /// Create a simple progress bar
  static String _createProgressBar(int percentage) {
    const barLength = 20;
    final filledLength = (barLength * percentage / 100).round();
    final bar = '█' * filledLength + '░' * (barLength - filledLength);
    return '[$bar] $percentage%';
  }
}
