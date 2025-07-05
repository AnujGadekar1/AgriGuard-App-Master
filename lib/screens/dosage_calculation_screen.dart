import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DosageCalculationScreen extends StatefulWidget {
  @override
  _DosageCalculationScreenState createState() => _DosageCalculationScreenState();
}

class _DosageCalculationScreenState extends State<DosageCalculationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _chemicalController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _concentrationController = TextEditingController();

  String _areaUnit = 'sq. meters';
  String _concentrationUnit = '%';
  String _applicationMethod = 'Spraying';
  String _weatherConditions = 'Sunny';
  String _moistureLevel = 'Dry';
  String _soilType = 'Sandy';

  double? _dosageResult;
  String _dosageUnit = 'units';

  @override
  void dispose() {
    _chemicalController.dispose();
    _areaController.dispose();
    _concentrationController.dispose();
    super.dispose();
  }

  void _calculateDosage() {
    if (_formKey.currentState!.validate()) {
      final double area = double.tryParse(_areaController.text)!;
      final double concentration = double.tryParse(_concentrationController.text)!;

      double areaInSqMeters = area;
      double concentrationInPercentage = concentration;

      if (_areaUnit == 'acres') {
        areaInSqMeters = area * 4046.86;
      } else if (_areaUnit == 'hectares') {
        areaInSqMeters = area * 10000;
      }

      if (_concentrationUnit == 'ppm') {
        concentrationInPercentage = concentration / 10000;
      }

      double applicationFactor = _getApplicationFactor(_applicationMethod);
      double soilFactor = _getSoilFactor(_soilType);
      double moistureFactor = _getMoistureFactor(_moistureLevel);
      double weatherFactor = _getWeatherFactor(_weatherConditions);

      setState(() {
        _dosageResult = areaInSqMeters *
            concentrationInPercentage *
            applicationFactor *
            soilFactor *
            moistureFactor *
            weatherFactor;
        
        _dosageUnit = _getDosageUnit(_chemicalController.text, _applicationMethod);
      });

      Fluttertoast.showToast(
        msg: "Dosage Calculated Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  double _getApplicationFactor(String method) {
    switch (method) {
      case 'Spraying':
        return 1.0;
      case 'Soil Application':
        return 1.2;
      case 'Foliar Application':
        return 0.8;
      default:
        return 1.0;
    }
  }

  double _getSoilFactor(String soil) {
    switch (soil.toLowerCase()) {
      case 'sandy':
        return 1.0;
      case 'clay':
        return 1.2;
      case 'loamy':
        return 1.1;
      default:
        return 1.0;
    }
  }

  double _getMoistureFactor(String moisture) {
    switch (moisture.toLowerCase()) {
      case 'dry':
        return 1.0;
      case 'moist':
        return 1.1;
      case 'wet':
        return 1.2;
      default:
        return 1.0;
    }
  }

  double _getWeatherFactor(String weather) {
    switch (weather.toLowerCase()) {
      case 'sunny':
        return 1.0;
      case 'cloudy':
        return 1.1;
      case 'rainy':
        return 1.2;
      default:
        return 1.0;
    }
  }

  String _getDosageUnit(String chemical, String method) {
    if (chemical.toLowerCase() == 'urea' && method == 'Soil Application') {
      return 'kg';
    }
    // Add more specific cases as needed
    return 'units';
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter the $fieldName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dosage Calculation'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _chemicalController,
                  decoration: InputDecoration(
                    labelText: 'Chemical Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) => _validateField(value, 'chemical name'),
                  onChanged: (value) {
                    setState(() {
                      if (value.toLowerCase() == 'urea') {
                        _applicationMethod = 'Soil Application';
                      }
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _areaController,
                        decoration: InputDecoration(
                          labelText: 'Area to be Treated',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => _validateField(value, 'area'),
                      ),
                    ),
                    SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _areaUnit,
                      onChanged: (String? newValue) {
                        setState(() {
                          _areaUnit = newValue!;
                        });
                      },
                      items: <String>['sq. meters', 'acres', 'hectares']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _concentrationController,
                        decoration: InputDecoration(
                          labelText: 'Concentration',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            _validateField(value, 'concentration'),
                      ),
                    ),
                    SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _concentrationUnit,
                      onChanged: (String? newValue) {
                        setState(() {
                          _concentrationUnit = newValue!;
                        });
                      },
                      items: <String>['%', 'ppm']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (_chemicalController.text.toLowerCase() != 'urea')
                  DropdownButtonFormField<String>(
                    value: _applicationMethod,
                    onChanged: (String? newValue) {
                      setState(() {
                        _applicationMethod = newValue!;
                      });
                    },
                    items: <String>[
                      'Spraying',
                      'Soil Application',
                      'Foliar Application'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Application Method',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                if (_chemicalController.text.toLowerCase() == 'urea')
                  DropdownButtonFormField<String>(
                    value: _applicationMethod,
                    onChanged: null,
                    items: <String>[
                      'Soil Application',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Application Method',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _soilType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _soilType = newValue!;
                    });
                  },
                  items: <String>['Sandy', 'Clay', 'Loamy']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Soil Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _moistureLevel,
                  onChanged: (String? newValue) {
                    setState(() {
                      _moistureLevel = newValue!;
                    });
                  },
                  items: <String>['Dry', 'Moist', 'Wet']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Moisture Level',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _weatherConditions,
                  onChanged: (String? newValue) {
                    setState(() {
                      _weatherConditions = newValue!;
                    });
                  },
                  items: <String>['Sunny', 'Cloudy', 'Rainy']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Weather Conditions',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _calculateDosage,
                    child: Text('Calculate Dosage'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                if (_dosageResult != null)
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Required Dosage:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$_dosageResult $_dosageUnit',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
