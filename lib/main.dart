import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MeasuresConverterApp());
}
/// Root widget for the Measures Converter application.
/// Provides MaterialApp configuration and sets the home screen.
class MeasuresConverterApp extends StatelessWidget {
  const MeasuresConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      debugShowCheckedModeBanner: false,
      // Material 2 theme is used here to match the assignment mockup appearance
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: UnderlineInputBorder(), //Ensures text fields have underlines
        ),
      ),
      home: const ConverterPage(),
    );
  }
}

///Utility class that contains conversion logic for multiple measurement categories.
///this separation keeps the widget tree clean and ensures the logic can be easily maintained.
class ConverterUnits {
  // Supported unit categories are grouped as constant lists.
  static const distanceUnits = <String>[
    'millimeters', 'centimeters', 'meters', 'kilometers',
    'inches','feet','yard','miles',
  ];

  static const weightUnits = <String>[
    'milligrams', 'grams', 'kilograms',
    'ounces', 'pounds',
  ];

  static const volumeUnits = <String>[
    'milliliters', 'liters',
    'teaspoons', 'tablespoons', 'fluid ounces',
    'cups', 'pints', 'quarts', 'gallons',
  ];

  static const temperatureUnits = <String>[
    'celsius', 'fahrenheit', 'kelvin',
  ];

  // Flattened list of all supported units, will be used directly in dropdowns.

  static const allUnits = <String>[
    ...distanceUnits,
    ...weightUnits,
    ...volumeUnits,
    ...temperatureUnits,
  ];

  // Distance conversion (base:meters)
  static double _toBaseDistance(String unit, double value){
    switch (unit) {
      case 'millimeters': return value * 0.001;
      case 'centimeters': return value * 0.01;
      case 'meters': return value;
      case 'kilometers': return value * 1000.0;
      case 'inches': return value * 0.0254;
      case 'feet': return value * 0.3048;
      case 'yards': return value * 0.9144;
      case 'miles': return value * 1609.344;
      default: return value;
    }
  }

  static double _fromBaseDistance(String unit, double base){
    switch (unit){
      case 'millimeters': return base / 0.001;
      case 'centimeters': return base / 0.01;
      case 'meters': return base;
      case 'kilometers': return base / 1000.0;
      case 'inches': return base / 0.0254;
      case 'feet': return base / 0.3048;
      case 'yards': return base / 0.9144;
      case 'miles': return base / 1609.344;
      default: return base;
    }
  }

  //Weight conversion(base:kilograms)
  static double _toBaseWeight(String unit, double value){
    switch (unit){
      case 'milligrams': return value * 1e-6;
      case 'grams': return value * 0.001;
      case 'kilograms': return value;
      case 'ounces': return value * 0.0283495;
      case 'pounds': return value * 0.453592;
      default: return value;
    }
  }

  static double _fromBaseWeight(String unit, double base){
    switch (unit){
      case 'milligrams': return base / 1e-6;
      case 'grams': return base / 0.001;
      case 'kilograms': return base;
      case 'ounces': return base / 0.0283495;
      case 'pounds': return base / 0.453592;
      default: return base;
    }
  }

  //Volume Conversion(base: liters/US measures)
  static double _toBaseVolume(String unit, double value){
    switch (unit){
      case 'milliliters': return value * 0.001;
      case 'liters': return value;
      case 'teaspoons': return value * 0.00492892;
      case 'tablespoons': return value * 0.0147868;
      case 'fluid ounces': return value * 0.0295735;
      case 'cups': return value * 0.2365;
      case 'pints': return value * 0.473176;
      case 'quarts': return value * 0.946353;
      case 'gallons': return value * 3.78541;
      default: return value;
    }
  }

  static double _fromBaseVolume(String unit, double base){
    switch (unit){
      case 'milliliters': return base / 0.001;
      case 'liters': return base;
      case 'teaspoons': return base / 0.00492892;
      case 'tablespoons': return base / 0.0147868;
      case 'fluid ounces': return base / 0.0295735;
      case 'cups': return base / 0.2365;
      case 'pints': return base / 0.473176;
      case 'quarts': return base / 0.946353;
      case 'gallons': return base / 3.78541;
      default: return base;
    }
  }

  // Temperature Conversion(base:celsius)
  static double _toBaseTemperature(String unit, double value){
    switch(unit){
      case 'celsius': return value;
      case 'fahrenheit': return (value-32) * 5 / 9;
      case 'kelvin': return value - 273.15;
      default: return value;
    }
  }

  static double _fromBaseTemperature(String unit, double base){
    switch(unit){
      case 'celsius': return base;
      case 'fahrenheit': return base * 9 / 5 + 32;
      case 'kelvin': return base + 273.15;
      default: return base;
    }
  }

  ///Public conversion entry point. Returns nul if units are incompatible.
  static double? convert(String from, String to, double value){
    if (from == to) return value;

    if (distanceUnits.contains(from) && distanceUnits.contains(to)) {
      final base = _toBaseDistance(from, value);
      return _fromBaseDistance(to, base);
    }

    if (weightUnits.contains(from) && weightUnits.contains(to)) {
      final base = _toBaseWeight(from, value);
      return _fromBaseWeight(to, base);
    }

    if (volumeUnits.contains(from) && volumeUnits.contains(to)) {
      final base = _toBaseVolume(from, value);
      return _fromBaseVolume(to, base);
    }

    if (temperatureUnits.contains(from) && temperatureUnits.contains(to)) {
      final base = _toBaseTemperature(from, value);
      return _fromBaseTemperature(to, base);
    }
    return null; //incompatible category
  }
  //Helper method to identify the category of a unit. Used for formatting results.

  static String categoryOf(String unit) {
    if (distanceUnits.contains(unit)) return 'distance';
    if (weightUnits.contains(unit)) return 'weight';
    if (volumeUnits.contains(unit)) return 'volume';
    if (temperatureUnits.contains(unit)) return 'temperature';
    return 'unknown';
  }
}

///Stateful widgets representing the converter page UI.
///Manage input values, selected units, and displays conversion results.
class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});
  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final TextEditingController _valueController = TextEditingController(text: '');
  String _fromUnit = 'meters';
  String _toUnit = 'feet';
  String? _resultText;

  ///Formats conversion result with appropriate precision.
  ///Distance/weights/volumes use 3 decimals; temperatures use 1 decimal
  String _formatResult(double input , double output, String from, String to, ) {
    final category = ConverterUnits.categoryOf(from);
    final inStr = input.toStringAsFixed(1);
    final outStr = (category == 'temperature')
        ? output.toStringAsFixed(1)
        : output.toStringAsFixed(3);
    return '$inStr $from are $outStr $to';
  }

  ///Handles conversion trigger: validates input, calls conversion logic,
  ///and updates the state with the result or error message.
  void _convert() {
    final raw = _valueController.text.trim();
    if (raw.isEmpty) {
      setState(() => _resultText = null);
      return;
    }
    final value = double.tryParse(raw);
    if (value == null) {
      setState(() => _resultText = 'Enter a valid number');
      return;
    }

    final out = ConverterUnits.convert(_fromUnit, _toUnit, value);
    if (out == null) {
      setState(() => _resultText = 'Choose compatible units');
      return;
    }
    setState(() => _resultText = _formatResult(value, out, _fromUnit, _toUnit));
    FocusScope.of(context).unfocus(); //Dismiss keyboard after conversion
  }

  /// Applications UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measures Converter'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          const SizedBox(height: 8),
          const Center(child: Text('Value', style: TextStyle(fontSize: 20))),
          TextField(
            controller: _valueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(),//underline only
            onSubmitted: (_) => _convert(),
          ),
          const SizedBox(height: 24),

          const Center(child: Text('From', style: TextStyle(fontSize: 20))),
          DropdownButtonFormField<String>(
            initialValue: _fromUnit,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            decoration: const InputDecoration(),
            items: ConverterUnits.allUnits.map((u) => DropdownMenuItem(
              value: u,
              child: Text(u, style: const TextStyle(color: Colors.blue)),
            )).toList(),
            onChanged: (v) {
              if (v == null) return;
              setState(() => _fromUnit = v);
            },
          ),
          const SizedBox(height: 24),

          const Center(child: Text('To', style: TextStyle(fontSize: 20))),
          DropdownButtonFormField<String>(
            initialValue: _toUnit,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            decoration: const InputDecoration(),
            items: ConverterUnits.allUnits.map((u) => DropdownMenuItem(
              value: u,
              child: Text(u, style: const TextStyle(color: Colors.blue)),
            )).toList(),
            onChanged: (v) {
              if (v == null) return;
              setState(() => _toUnit = v);
            },
          ),

          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.blue,
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              onPressed: _convert,
              child: const Text('Convert'),
            ),
          ),
          const SizedBox(height: 24),

          if (_resultText != null)
            Center(
              child: Text(
                _resultText!,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
        ],
      ),
    );
  }
}

