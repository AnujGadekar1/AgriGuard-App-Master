import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'leave_note_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leave Note & Audit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LeaveNoteScreen(),
    );
  }
}


class LeaveNoteScreen extends StatefulWidget {
  @override
  _LeaveNoteScreenState createState() => _LeaveNoteScreenState();
}

class _LeaveNoteScreenState extends State<LeaveNoteScreen> {
  final List<Note> _notes = [];
  final List<Audit> _audits = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _chemicalNameController = TextEditingController();
  final TextEditingController _chemicalPriceController =
      TextEditingController();

  DateTime? _selectedReminderDate;

  String _searchQuery = '';
  final List<String> _categories = ['Work', 'Personal', 'Other'];
  String? _selectedCategory;

  final ImagePicker _picker = ImagePicker();

  void _addOrEditNote({Note? note}) {
    if (note != null) {
      _titleController.text = note.title;
      _contentController.text = note.content;
      _selectedCategory = note.category;
      _selectedReminderDate = note.reminderDate;
    } else {
      _titleController.clear();
      _contentController.clear();
      _selectedCategory = null;
      _selectedReminderDate = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note == null ? 'Add Note' : 'Edit Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: 'Content'),
                  maxLines: 3,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(labelText: 'Category'),
                  items: _categories
                      .map((category) => DropdownMenuItem(
                          value: category, child: Text(category)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedReminderDate == null
                            ? 'No Reminder Set'
                            : 'Reminder: ${DateFormat('yyyy-MM-dd – kk:mm').format(_selectedReminderDate!)}',
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedReminderDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                _selectedReminderDate ?? DateTime.now()),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _selectedReminderDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (note == null) {
                    _notes.add(Note(
                      title: _titleController.text,
                      content: _contentController.text,
                      category: _selectedCategory ?? 'Other',
                      reminderDate: _selectedReminderDate,
                    ));
                  } else {
                    note.title = _titleController.text;
                    note.content = _contentController.text;
                    note.category = _selectedCategory ?? 'Other';
                    note.reminderDate = _selectedReminderDate;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text(note == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(Note note) {
    setState(() {
      _notes.remove(note);
    });
  }

  Future<void> _pickImage(Audit audit) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        audit.receiptImage = File(pickedFile.path);
      });
    }
  }

  void _addAudit() {
    _chemicalNameController.clear();
    _chemicalPriceController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Audit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _chemicalNameController,
                  decoration: InputDecoration(labelText: 'Chemical Name'),
                ),
                TextField(
                  controller: _chemicalPriceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _audits.add(Audit(
                    chemicalName: _chemicalNameController.text,
                    price: double.parse(_chemicalPriceController.text),
                  ));
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAudit(Audit audit) {
    setState(() {
      _audits.remove(audit);
    });
  }

  void _generateReceipt() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Receipt'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _audits.map((audit) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${audit.chemicalName}: \$${audit.price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      if (audit.receiptImage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Image.file(
                            audit.receiptImage!,
                            width: 100,
                            height: 100,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Note> filteredNotes = _notes
        .where((note) =>
            note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            note.content.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Note & Audit'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Notes',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note.content),
                        if (note.category != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Chip(
                              label: Text(note.category!),
                            ),
                          ),
                        if (note.reminderDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                                'Reminder: ${DateFormat('yyyy-MM-dd – kk:mm').format(note.reminderDate!)}'),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _addOrEditNote(note: note),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteNote(note),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Audits',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _audits.length,
              itemBuilder: (context, index) {
                final audit = _audits[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(audit.chemicalName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: \$${audit.price.toStringAsFixed(2)}'),
                        if (audit.receiptImage != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.file(
                              audit.receiptImage!,
                              width: 100,
                              height: 100,
                            ),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.photo),
                          onPressed: () => _pickImage(audit),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteAudit(audit),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _generateReceipt,
              child: Text('Generate Receipt'),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _addOrEditNote(),
            child: Icon(Icons.note_add),
            heroTag: 'addNote',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _addAudit,
            child: Icon(Icons.add_shopping_cart),
            heroTag: 'addAudit',
          ),
        ],
      ),
    );
  }
}

class Note {
  String title;
  String content;
  String? category;
  DateTime? reminderDate;

  Note({
    required this.title,
    required this.content,
    this.category,
    this.reminderDate,
  });
}

class Audit {
  String chemicalName;
  double price;
  File? receiptImage;

  Audit({
    required this.chemicalName,
    required this.price,
    this.receiptImage,
  });
}
