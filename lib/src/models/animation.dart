/// Represents an animation within a Rive artboard.
class RiveAnimation {
  /// The name of the animation
  final String name;

  /// The generated property name for this animation
  final String propertyName;

  /// The duration of the animation in seconds
  final double duration;

  /// The frame rate of the animation
  final double fps;

  /// Whether the animation loops
  final bool isLooping;

  /// The work area start time (if defined)
  final double? workAreaStart;

  /// The work area end time (if defined)
  final double? workAreaEnd;

  /// Constructor
  const RiveAnimation({
    required this.name,
    required this.propertyName,
    required this.duration,
    required this.fps,
    this.isLooping = false,
    this.workAreaStart,
    this.workAreaEnd,
  });

  /// Gets the total number of frames in this animation
  int get totalFrames => (duration * fps).round();

  /// Gets the effective start time (work area start or 0)
  double get effectiveStartTime => workAreaStart ?? 0.0;

  /// Gets the effective end time (work area end or duration)
  double get effectiveEndTime => workAreaEnd ?? duration;

  /// Gets the effective duration (considering work area)
  double get effectiveDuration => effectiveEndTime - effectiveStartTime;

  @override
  String toString() =>
      'RiveAnimation(name: $name, duration: ${duration}s, fps: $fps, looping: $isLooping)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiveAnimation &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
