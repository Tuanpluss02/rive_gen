/// Enumeration of Rive input types.
enum RiveInputType {
  /// Trigger input - fires once when called
  trigger,

  /// Boolean input - true/false value
  boolean,

  /// Number input - numeric value
  number,
}

/// Base class for all Rive inputs.
abstract class RiveInput {
  /// The name of the input
  final String name;

  /// The generated property name for this input
  final String propertyName;

  /// The type of input
  final RiveInputType type;

  /// Constructor
  const RiveInput({
    required this.name,
    required this.propertyName,
    required this.type,
  });

  @override
  String toString() => 'RiveInput(name: $name, type: $type)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiveInput &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

/// Represents a trigger input in a Rive state machine.
class RiveTriggerInput extends RiveInput {
  /// Constructor
  const RiveTriggerInput({required super.name, required super.propertyName})
    : super(type: RiveInputType.trigger);
}

/// Represents a boolean input in a Rive state machine.
class RiveBooleanInput extends RiveInput {
  /// The initial value of this boolean input
  final bool initialValue;

  /// Constructor
  const RiveBooleanInput({
    required super.name,
    required super.propertyName,
    this.initialValue = false,
  }) : super(type: RiveInputType.boolean);
}

/// Represents a number input in a Rive state machine.
class RiveNumberInput extends RiveInput {
  /// The initial value of this number input
  final double initialValue;

  /// The minimum value allowed
  final double? minValue;

  /// The maximum value allowed
  final double? maxValue;

  /// Constructor
  const RiveNumberInput({
    required super.name,
    required super.propertyName,
    this.initialValue = 0.0,
    this.minValue,
    this.maxValue,
  }) : super(type: RiveInputType.number);
}
