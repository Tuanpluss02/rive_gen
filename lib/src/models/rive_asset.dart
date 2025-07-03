/// Represents a Rive asset file with its metadata and components.
class RiveAsset {
  /// The path to the Rive file
  final String path;

  /// The name of the asset (derived from filename)
  final String name;

  /// The generated class name for this asset
  final String className;

  /// All artboards found in this Rive file
  final List<RiveArtboard> artboards;

  /// The default artboard (usually the first one)
  RiveArtboard? get defaultArtboard =>
      artboards.isNotEmpty ? artboards.first : null;

  /// Constructor
  const RiveAsset({
    required this.path,
    required this.name,
    required this.className,
    required this.artboards,
  });

  /// Creates a RiveAsset from a file path
  factory RiveAsset.fromPath(String path) {
    final name = _extractNameFromPath(path);
    return RiveAsset(
      path: path,
      name: name,
      className: _toClassName(name),
      artboards: [], // Will be populated by parser
    );
  }

  /// Extract asset name from file path
  static String _extractNameFromPath(String path) {
    return path.split('/').last.replaceAll('.riv', '');
  }

  /// Convert name to valid Dart class name
  static String _toClassName(String name) {
    return name
        .split('_')
        .map(
          (word) =>
              word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
        )
        .join('');
  }

  @override
  String toString() =>
      'RiveAsset(path: $path, name: $name, artboards: ${artboards.length})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiveAsset &&
          runtimeType == other.runtimeType &&
          path == other.path;

  @override
  int get hashCode => path.hashCode;
}
