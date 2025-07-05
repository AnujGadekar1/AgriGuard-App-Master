import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditMode = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  String? _profilePictureUrl;
  File? _newProfilePicture;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

      if (userData.exists) {
        setState(() {
          _nameController.text = userData['name'] ?? 'John Doe';
          _emailController.text = userData['email'] ?? 'john.doe@example.com';
          _phoneNumberController.text = userData['phoneNumber'] ?? '+1234567890';
          _addressController.text = userData['address'] ?? '123 Main St, Anytown, USA';
          _profilePictureUrl = userData['profilePictureUrl'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newProfilePicture = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadProfilePicture(File imageFile) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Reference ref = FirebaseStorage.instance.ref().child('profile_pictures').child(user.uid);
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Iconsax.edit4),
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _newProfilePicture != null
                          ? FileImage(_newProfilePicture!)
                          : _profilePictureUrl != null
                              ? NetworkImage(_profilePictureUrl!)
                              : AssetImage('assets/profile_picture.png') as ImageProvider,
                    ),
                    if (_isEditMode)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey[200],
                            child: Icon(Icons.camera_alt, size: 15),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildProfileField(
                label: 'Name',
                controller: _nameController,
                isEditable: _isEditMode,
              ),
              _buildProfileField(
                label: 'Email',
                controller: _emailController,
                isEditable: false,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              _buildProfileField(
                label: 'Phone Number',
                controller: _phoneNumberController,
                isEditable: _isEditMode,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              _buildProfileField(
                label: 'Address',
                controller: _addressController,
                isEditable: _isEditMode,
              ),
              SizedBox(height:              20),
              if (_isEditMode)
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_validateAndSave()) {
                        if (_newProfilePicture != null) {
                          String newUrl = await _uploadProfilePicture(_newProfilePicture!);
                          setState(() {
                            _profilePictureUrl = newUrl;
                            _newProfilePicture = null;
                          });
                        }
                        await _saveUserData(); // Save the updated data to Firestore
                        await _fetchUserData(); // Re-fetch the updated data
                        setState(() {
                          _isEditMode = false;
                        });
                      }
                    },
                    child: Text('Save'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    required bool isEditable,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          enabled: isEditable,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter $label',
            errorText: isEditable
                ? (validator != null ? validator(controller.text) : null)
                : null,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  bool _validateAndSave() {
    if (_phoneNumberController.text.isEmpty || _phoneNumberController.text.length != 10) {
      _showErrorDialog('Invalid Phone Number', 'Please enter a valid phone number.');
      return false;
    }

    return true;
  }

  Future<void> _saveUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
        'address': _addressController.text,
        'profilePictureUrl': _profilePictureUrl,
      }, SetOptions(merge: true));
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


