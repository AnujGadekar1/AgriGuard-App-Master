import 'package:flutter/material.dart';
import 'dosage_calculation_screen.dart';
import 'application_tracking_screen.dart';
import 'safety_guidance_screen.dart';
import 'regulatory_compliance_screen.dart';
import 'weather_integration_screen.dart';
import 'pest_disease_identification_screen.dart';
import 'leave_note_screen.dart'; // Import your LeaveNoteScreen here
import 'profile_screen.dart'; // Import your ProfileScreen here
import 'package:iconsax/iconsax.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, 
        title: Row(
          children: [
            Text('Welcome to, AgriGuard'), // Display welcome message
            Spacer(), // Add spacer to push the icon to the opposite side
            IconButton(
              icon: Icon(Iconsax.notification), // Notification icon
              onPressed: () {
                // Navigate to a notification screen or show a dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Notifications'),
                      content: Text('You have no new notifications.'),
                      actions: [
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'AgroChemical Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DosageCalculationScreen()),
                      );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SafetyGuidanceScreen()),
                      );
                    },
                  ),
                  HomeScreenButton(
                    title: 'Regulatory Compliance',
                    icon: Icons.rule,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegulatoryComplianceScreen()),
                      );
                    },
                  ),
                  HomeScreenButton(
                    title: 'Weather Info And Alerts',
                    icon: Icons.cloud,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WeatherIntegrationScreen()),
                      );
                    },
                  ),
                  HomeScreenButton(
                    title: 'Plant Species ',
                    icon: Icons.bug_report,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PestDiseaseIdentificationScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.note_add),
            label: 'Leave Note',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Handle navigation to HomeScreen
              break;
            case 1:
              // Handle navigation to LeaveNoteScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeaveNoteScreen()),
              );
              break;
            case 2:
              // Handle navigation to ProfileScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              break;
          }
        },
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
