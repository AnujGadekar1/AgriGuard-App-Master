import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroChemical Management',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AgroChemical Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            HomeScreenButton(
              title: 'Dosage Calculation',
              icon: Icons.calculate,
              onTap: () {
                // Navigate to Dosage Calculation screen
              },
            ),
            HomeScreenButton(
              title: 'Application Tracking',
              icon: Icons.track_changes,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ApplicationTrackingScreen()),
                );
              },
            ),
            HomeScreenButton(
              title: 'Safety Guidance',
              icon: Icons.security,
              onTap: () {
                // Navigate to Safety Guidance screen
              },
            ),
            HomeScreenButton(
              title: 'Regulatory Compliance',
              icon: Icons.rule,
              onTap: () {
                // Navigate to Regulatory Compliance screen
              },
            ),
            HomeScreenButton(
              title: 'Weather Integration',
              icon: Icons.cloud,
              onTap: () {
                // Navigate to Weather Integration screen
              },
            ),
            HomeScreenButton(
              title: 'Pest & Disease Identification',
              icon: Icons.bug_report,
              onTap: () {
                // Navigate to Pest & Disease Identification screen
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreenButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const HomeScreenButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.green[800]),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Application {
  String id;
  final String chemicalName;
  final String status;
  final String dose;
  final String date;
  final String nextDose;

  Application({
    required this.id,
    required this.chemicalName,
    required this.status,
    required this.dose,
    required this.date,
    required this.nextDose,
  });

  factory Application.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Application(
      id: doc.id,
      chemicalName: data['chemicalName'] ?? '',
      status: data['status'] ?? '',
      dose: data['dose'] ?? '',
      date: data['date'] ?? '',
      nextDose: data['nextDose'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'chemicalName': chemicalName,
      'status': status,
      'dose': dose,
      'date': date,
      'nextDose': nextDose,
    };
  }
}

class ApplicationTrackingScreen extends StatefulWidget {
  @override
  _ApplicationTrackingScreenState createState() =>
      _ApplicationTrackingScreenState();
}

class _ApplicationTrackingScreenState extends State<ApplicationTrackingScreen> {
  List<Application> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('applications').get();

    setState(() {
      _applications = querySnapshot.docs
          .map((doc) => Application.fromFirestore(doc))
          .toList();
      _isLoading = false;
    });
  }

  // Function to navigate to the screen for adding a new application
  void _navigateToAddApplicationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddApplicationScreen(
                onAddApplication: (newApplication) {
                  setState(() {
                    _applications.add(newApplication);
                  });
                },
              )),
    );
  }

  // Function to navigate to the screen for editing an existing application
  void _navigateToEditApplicationScreen(Application application) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditApplicationScreen(
                application: application,
                onUpdateApplication: (updatedApplication) {
                  setState(() {
                    // Find the index of the updated application
                    int index = _applications
                        .indexWhere((app) => app.id == application.id);
                    if (index != -1) {
                      _applications[index] = updatedApplication;
                    }
                  });
                },
              )),
    );
  }

  // Function to delete an application
  Future<void> _deleteApplication(String id) async {
    await FirebaseFirestore.instance
        .collection('applications')
        .doc(id)
        .delete();
    setState(() {
      _applications.removeWhere((application) => application.id == id);
    });
  }

  // Show confirmation dialog before deleting an application
  void _showDeleteConfirmationDialog(Application application) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Application'),
          content: Text('Are you sure you want to delete this application?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteApplication(application.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application Tracking'),
      ),
      body: _isLoading
          ? Center(
              child: SpinKitCircle(
                color: Colors.green,
                size: 50.0,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: _applications.isEmpty
                  ? Center(child: Text('No data found!'))
                  : StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      itemCount: _applications.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ApplicationCard(
                        application: _applications[index],
                        onTap: () {
                          _navigateToEditApplicationScreen(
                              _applications[index]);
                        },
                        onLongPress: () {
                          _showDeleteConfirmationDialog(_applications[index]);
                        },
                      ),
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddApplicationScreen,
        child: Icon(Icons.add),
      ),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final Application application;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  ApplicationCard({
    required this.application,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Chemical Name: ${application.chemicalName}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('Status: ${application.status}'),
              SizedBox(height: 8.0),
              Text('Dose: ${application.dose}'),
              SizedBox(height: 8.0),
              Text('Date: ${application.date}'),
              SizedBox(height: 8.0),
              Text('Next Dose: ${application.nextDose}'),
            ],
          ),
        ),
      ),
    );
  }
}

class AddApplicationScreen extends StatefulWidget {
  final Function(Application) onAddApplication;

  AddApplicationScreen({required this.onAddApplication});

  @override
  _AddApplicationScreenState createState() => _AddApplicationScreenState();
}

class _AddApplicationScreenState extends State<AddApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _chemicalNameController = TextEditingController();
  final _doseController = TextEditingController();
  final _dateController = TextEditingController();
  final _nextDoseController = TextEditingController();
  String? _status = 'Pending'; // Default value

  final List<String> _statusOptions = ['Pending', 'In Progress', 'Completed'];

  Future<void> _addApplication() async {
    if (_formKey.currentState!.validate()) {
      final newApplication = Application(
        id: '',
        chemicalName: _chemicalNameController.text,
        status: _status!,
        dose: _doseController.text,
        date: _dateController.text,
        nextDose: _nextDoseController.text,
      );

      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('applications')
          .add(newApplication.toFirestore());
      newApplication.id = docRef.id;

      widget.onAddApplication(newApplication);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Application'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _chemicalNameController,
                decoration: InputDecoration(labelText: 'Chemical Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter chemical name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Status'),
                value: _status,
                items: _statusOptions.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a status';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _doseController,
                decoration: InputDecoration(labelText: 'Dose'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter dose';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: () => _selectDate(context, _dateController),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nextDoseController,
                decoration: InputDecoration(labelText: 'Next Dose Date'),
                readOnly: true,
                onTap: () => _selectDate(context, _nextDoseController),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter next dose date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addApplication,
                child: Text('Add Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditApplicationScreen extends StatefulWidget {
  final Application application;
  final Function(Application) onUpdateApplication;

  EditApplicationScreen({
    required this.application,
    required this.onUpdateApplication,
  });

  @override
  _EditApplicationScreenState createState() => _EditApplicationScreenState();
}

class _EditApplicationScreenState extends State<EditApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _chemicalNameController;
  late TextEditingController _doseController;
  late TextEditingController _dateController;
  late TextEditingController _nextDoseController;
  String? _status; // Default value

  final List<String> _statusOptions = ['Pending', 'In Progress', 'Completed'];

  @override
  void initState() {
    super.initState();
    _chemicalNameController =
        TextEditingController(text: widget.application.chemicalName);
    _status = widget.application.status;
    _doseController = TextEditingController(text: widget.application.dose);
    _dateController = TextEditingController(text: widget.application.date);
    _nextDoseController =
        TextEditingController(text: widget.application.nextDose);
  }

  Future<void> _updateApplication() async {
    if (_formKey.currentState!.validate()) {
      final updatedApplication = Application(
        id: widget.application.id,
        chemicalName: _chemicalNameController.text,
        status: _status!,
        dose: _doseController.text,
        date: _dateController.text,
        nextDose: _nextDoseController.text,
      );

      await FirebaseFirestore.instance
          .collection('applications')
          .doc(updatedApplication.id)
          .update(updatedApplication.toFirestore());

      widget.onUpdateApplication(updatedApplication);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.application.date),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Application'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _chemicalNameController,
                decoration: InputDecoration(labelText: 'Chemical Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter chemical name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Status'),
                value: _status,
                items: _statusOptions.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a status';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _doseController,
                decoration: InputDecoration(labelText: 'Dose'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter dose';
                  }
                  return null;
                },
              ),
              TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                  readOnly: true,
                  onTap: () => _selectDate(context, _dateController),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter date';
                    }
                    return null;
                  }),
              TextFormField(
                controller: _nextDoseController,
                decoration: InputDecoration(labelText: 'Next Dose Date'),
                readOnly: true,
                onTap: () => _selectDate(context, _nextDoseController),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter next dose date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateApplication,
                child: Text('Update Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
