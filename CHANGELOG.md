# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

### 🎉 Initial Release

This is the first release of `rive_gen` - a powerful code generator for Rive assets!

### ✨ Added

#### Core Features
- **Type-safe asset references** - Generate Dart classes for Rive assets
- **Configuration system** - Flexible YAML-based configuration
- **Command-line interface** - Full-featured CLI with multiple options
- **Build runner integration** - Seamless integration with Dart's build system

#### Models & Architecture
- **RiveAsset** - Core model representing Rive files
- **RiveArtboard** - Model for artboards within Rive files
- **RiveStateMachine** - Model for state machines
- **RiveAnimation** - Model for animations
- **RiveInput** - Models for different input types (trigger, boolean, number)

#### Code Generation
- **Asset class generation** - Individual classes for each Rive file
- **Controller generation** - Framework for type-safe controllers (planned)
- **Barrel file generation** - Convenient single import file
- **Customizable output** - Configurable class names and structure

#### Utilities
- **File operations** - Robust file finding and management
- **Naming conventions** - Smart conversion between naming styles
- **Logging system** - Comprehensive logging with color support
- **Configuration management** - YAML configuration loading and validation

#### CLI Features
- `--help` - Show usage information
- `--debug` - Enable debug logging
- `--watch` - Watch for file changes (planned)
- `--create-config` - Generate sample configuration
- `--config` - Specify custom config file
- `--assets-path` - Override assets directory
- `--output-dir` - Override output directory

### 🔮 Planned Features

The following features are planned for future releases:

- **Rive file parsing** - Direct `.riv` file analysis
- **Complete controller implementation** - Full state machine control
- **File watching** - Automatic regeneration on changes
- **Animation properties** - Duration, FPS, looping detection
- **Event listeners** - Type-safe event handling
- **Multiple artboard support** - Handle complex Rive files

### 🛠️ Technical Details

- **Dart SDK**: ^3.8.1
- **Dependencies**: build, source_gen, yaml, args, path
- **Architecture**: Plugin-based generators with modular design
