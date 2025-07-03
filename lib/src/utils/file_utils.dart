import 'dart:io';

import 'package:path/path.dart' as path;

/// Utilities for file operations and path handling.
class FileUtils {
  /// Find all Rive files matching the given pattern
  static Future<List<String>> findRiveFiles(String pattern) async {
    final files = <String>[];

    // Extract base directory from pattern
    final baseDir = _extractBaseDirectory(pattern);
    final directory = Directory(baseDir);

    if (await directory.exists()) {
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.riv')) {
          // Check if the file matches the pattern
          if (_matchesPattern(entity.path, pattern)) {
            files.add(entity.path);
          }
        }
      }
    }

    return files;
  }

  /// Extract base directory from glob pattern
  static String _extractBaseDirectory(String pattern) {
    // Extract the directory part before any glob characters
    final parts = pattern.split('/');
    final baseParts = <String>[];

    for (final part in parts) {
      if (part.contains('*') || part.contains('?') || part.contains('[')) {
        break;
      }
      baseParts.add(part);
    }

    return baseParts.isEmpty ? '.' : baseParts.join('/');
  }

  /// Simple pattern matching for basic glob patterns
  static bool _matchesPattern(String filePath, String pattern) {
    // For now, support simple ** patterns
    if (pattern.contains('**')) {
      final parts = pattern.split('**');
      if (parts.length == 2) {
        final prefix = parts[0];
        final suffix = parts[1];
        return filePath.startsWith(prefix) && filePath.endsWith(suffix);
      }
    }

    // Exact match
    return filePath == pattern;
  }

  /// Ensure a directory exists, creating it if necessary
  static Future<void> ensureDirectoryExists(String dirPath) async {
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  /// Write content to a file, creating directories if necessary
  static Future<void> writeFile(String filePath, String content) async {
    final file = File(filePath);
    await ensureDirectoryExists(path.dirname(filePath));
    await file.writeAsString(content);
  }

  /// Read content from a file
  static Future<String> readFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('File not found', filePath);
    }
    return await file.readAsString();
  }

  /// Check if a file exists
  static Future<bool> fileExists(String filePath) async {
    return await File(filePath).exists();
  }

  /// Get the relative path from one directory to another
  static String getRelativePath(String from, String to) {
    return path.relative(to, from: from);
  }

  /// Get the file name without extension
  static String getFileNameWithoutExtension(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }

  /// Get the file extension
  static String getFileExtension(String filePath) {
    return path.extension(filePath);
  }

  /// Join path segments
  static String joinPath(List<String> segments) {
    return path.joinAll(segments);
  }

  /// Normalize a path
  static String normalizePath(String filePath) {
    return path.normalize(filePath);
  }

  /// Convert a file path to a valid import path
  static String toImportPath(String filePath, {String? packageName}) {
    if (packageName != null) {
      // Convert to package import
      final relativePath = filePath.replaceAll(path.separator, '/');
      if (relativePath.startsWith('lib/')) {
        return 'package:$packageName/${relativePath.substring(4)}';
      }
    }

    // Return relative import
    return filePath.replaceAll(path.separator, '/');
  }

  /// Get the modification time of a file
  static Future<DateTime?> getModificationTime(String filePath) async {
    try {
      final file = File(filePath);
      final stat = await file.stat();
      return stat.modified;
    } catch (e) {
      return null;
    }
  }

  /// Check if source file is newer than target file
  static Future<bool> isSourceNewer(
    String sourcePath,
    String targetPath,
  ) async {
    if (!await fileExists(targetPath)) {
      return true; // Target doesn't exist, so source is "newer"
    }

    final sourceTime = await getModificationTime(sourcePath);
    final targetTime = await getModificationTime(targetPath);

    if (sourceTime == null || targetTime == null) {
      return true; // If we can't determine, assume source is newer
    }

    return sourceTime.isAfter(targetTime);
  }

  /// Delete a file if it exists
  static Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Delete a directory and all its contents
  static Future<void> deleteDirectory(String dirPath) async {
    final directory = Directory(dirPath);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  /// Copy a file to another location
  static Future<void> copyFile(String sourcePath, String targetPath) async {
    final sourceFile = File(sourcePath);
    await ensureDirectoryExists(path.dirname(targetPath));
    await sourceFile.copy(targetPath);
  }
}
