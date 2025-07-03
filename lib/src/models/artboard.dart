import 'animation.dart';
import 'state_machine.dart';

/// Represents an artboard within a Rive file.
class RiveArtboard {
  /// The name of the artboard
  final String name;

  /// The generated class name for this artboard
  final String className;

  /// All state machines in this artboard
  final List<RiveStateMachine> stateMachines;

  /// All animations in this artboard
  final List<RiveAnimation> animations;

  /// Whether this is the default artboard
  final bool isDefault;

  /// Constructor
  const RiveArtboard({
    required this.name,
    required this.className,
    required this.stateMachines,
    required this.animations,
    this.isDefault = false,
  });

  /// Get the default state machine (first one if available)
  RiveStateMachine? get defaultStateMachine =>
      stateMachines.isNotEmpty ? stateMachines.first : null;

  /// Get a state machine by name
  RiveStateMachine? getStateMachine(String name) {
    for (final sm in stateMachines) {
      if (sm.name == name) return sm;
    }
    return null;
  }

  /// Get an animation by name
  RiveAnimation? getAnimation(String name) {
    for (final anim in animations) {
      if (anim.name == name) return anim;
    }
    return null;
  }

  @override
  String toString() =>
      'RiveArtboard(name: $name, stateMachines: ${stateMachines.length}, animations: ${animations.length})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiveArtboard &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
