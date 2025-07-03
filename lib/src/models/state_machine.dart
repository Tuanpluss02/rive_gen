/// Represents a state machine within a Rive artboard.
class RiveStateMachine {
  /// The name of the state machine
  final String name;

  /// The generated class name for this state machine
  final String className;

  /// All inputs available in this state machine
  final List<RiveInput> inputs;

  /// All states in this state machine
  final List<String> states;

  /// The initial state name
  final String? initialState;

  /// Constructor
  const RiveStateMachine({
    required this.name,
    required this.className,
    required this.inputs,
    required this.states,
    this.initialState,
  });

  /// Get an input by name
  RiveInput? getInput(String name) => inputs.cast<RiveInput?>().firstWhere(
    (input) => input?.name == name,
    orElse: () => null,
  );

  /// Get all trigger inputs
  List<RiveInput> get triggers =>
      inputs.where((input) => input.type == RiveInputType.trigger).toList();

  /// Get all boolean inputs
  List<RiveInput> get booleans =>
      inputs.where((input) => input.type == RiveInputType.boolean).toList();

  /// Get all number inputs
  List<RiveInput> get numbers =>
      inputs.where((input) => input.type == RiveInputType.number).toList();

  @override
  String toString() =>
      'RiveStateMachine(name: $name, inputs: ${inputs.length}, states: ${states.length})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiveStateMachine &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
