import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class SafetyGuidanceScreen extends StatefulWidget {
  @override
  _SafetyGuidanceScreenState createState() => _SafetyGuidanceScreenState();
}

class _SafetyGuidanceScreenState extends State<SafetyGuidanceScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _guidelines = [
    {
      'title': 'Personal Protective Equipment (PPE)',
      'icon': Icons.security,
      'description':
          'Always wear appropriate PPE such as gloves, masks, goggles, and protective clothing when handling agrochemicals.',
    },
    {
      'title': 'Safe Storage',
      'icon': Icons.storage,
      'description':
          'Store agrochemicals in a secure, well-ventilated area, away from food, feed, and water sources. Ensure they are kept out of reach of children and animals.',
    },
    {
      'title': 'Proper Handling',
      'icon': Icons.handyman,
      'description':
          'Read and follow the label instructions carefully. Use only the recommended amount to avoid over-application.',
    },
    {
      'title': 'Environmental Protection',
      'icon': Icons.eco,
      'description':
          'Avoid contamination of water bodies by maintaining a safe distance when applying agrochemicals. Dispose of empty containers properly according to local regulations.',
    },
    {
      'title': 'Emergency Procedures',
      'icon': Icons.emergency,
      'description':
          'Be prepared for emergencies by having first aid kits and emergency contact numbers readily available. In case of accidental exposure or spillage, follow the emergency instructions provided on the chemical label.',
    },
    {
      'title': 'Training and Awareness',
      'icon': Icons.school,
      'description':
          'Ensure that all personnel involved in the handling and application of agrochemicals are adequately trained and aware of the potential hazards and safety measures.',
    },
    {
      'title': 'Record Keeping',
      'icon': Icons.book,
      'description':
          'Maintain accurate records of agrochemical usage, including the type of chemical, quantity, application date, and field location. This helps in tracking chemical use and managing reapplications effectively.',
    },
  ];

  final Map<String, List<String>> _chemicalGuidelines = {
    'Urea': [
      'Wear gloves and masks to avoid inhalation and skin contact.',
      'Store in a cool, dry place away from moisture.',
      'Avoid mixing with other chemicals unless specified.',
    ],
    'Ammonium Nitrate': [
      'Handle with care as it is highly reactive.',
      'Store in a well-ventilated area away from heat sources.',
      'Use proper equipment to avoid spillage and contamination.',
    ],
    'Potassium Chloride': [
      'Avoid inhalation by wearing masks.',
      'Store in tightly sealed containers.',
      'Use eye protection to prevent irritation from dust.',
    ],
    'Glyphosate': [
      'Use only as directed to avoid harm to non-target plants.',
      'Wear protective clothing to prevent skin contact.',
      'Wash thoroughly after handling and before eating.',
    ],
    'Paraquat': [
      'Highly toxic - use with extreme caution.',
      'Ensure no skin exposure by wearing full protective gear.',
      'Store securely away from all sources of ignition.',
    ],
  };

  final List<Map<String, String>> _emergencyContacts = [
    {'title': 'Poison Control', 'contact': '1-800-222-1222'},
    {'title': 'Local Emergency Services', 'contact': '911'},
    {
      'title': 'Agrochemical Safety Manual',
      'contact': 'Download PDF',
      'link': 'https://google.com'
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentSection;
    if (_selectedIndex == 0) {
      currentSection = _buildGuidelinesSection();
    } else if (_selectedIndex == 1) {
      currentSection = _buildEquipmentAndPurchaseSection();
    } else {
      currentSection = _buildEmergencyContactsSection();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Guidance'),
      ),
      body: currentSection,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Iconsax.book),
            label: 'Guidelines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.shopping_bag),
            label: 'Equipment & Purchase',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.call),
            label: 'Emergency Contacts',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildGuidelinesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Safety Guidelines for Agrochemical Use',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          for (var guideline in _guidelines)
            _buildSafetyGuideline(
              title: guideline['title'],
              icon: guideline['icon'],
              description: guideline['description'],
            ),
          SizedBox(height: 20),
          Text(
            'Handling Common Fertilizers and Chemicals Safely',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          for (var chemicalGuideline in _chemicalGuidelines.entries)
            _buildChemicalGuideline(
              chemicalName: chemicalGuideline.key,
              guidelines: chemicalGuideline.value,
            ),
        ],
      ),
    );
  }

  Widget _buildSafetyGuideline({
    required String? title,
    required IconData? icon,
    required String? description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  description!,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChemicalGuideline({
    required String chemicalName,
    required List<String> guidelines,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chemicalName,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          ...guidelines.map((guideline) => Text(
                '- $guideline',
                style: TextStyle(fontSize: 16),
              )),
        ],
      ),
    );
  }

  Widget _buildEquipmentAndPurchaseSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Equipment & Purchase Section',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildEquipmentInfo(
            equipmentName: 'Sprayer',
            usage:
                'Used for applying pesticides and fertilizers evenly over crops.',
            icon: Icons.local_florist,
          ),
          _buildEquipmentInfo(
            equipmentName: 'Safety Goggles',
            usage:
                'Used to protect the eyes from chemical splashes and dust particles.',
            icon: Icons.remove_red_eye,
          ),
          _buildEquipmentInfo(
            equipmentName: 'Respirator Mask',
            usage:
                'Used to protect the respiratory system from inhaling chemical fumes and dust.',
            icon: Icons.masks,
          ),
          _buildEquipmentInfo(
            equipmentName: 'Coveralls',
            usage:
                'Used to cover the body completely and protect the skin from chemical exposure.',
            icon: Icons.format_color_fill,
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Contacts Section',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          for (var contact in _emergencyContacts)
            _buildContactInfo(
              title: contact['title']!,
              contact: contact['contact']!,
              link: contact['link'],
            ),
        ],
      ),
    );
  }

  Widget _buildContactInfo({
    required String title,
    required String contact,
    String? link,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(Icons.contact_phone, size: 30, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: link != null
                      ? () async {
                          final url = link;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      : null,
                  child: Text(
                    contact,
                    style: TextStyle(
                      fontSize: 16,
                      color: link != null ? Colors.blue : Colors.black,
                      decoration:
                          link != null ? TextDecoration.underline : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentInfo({
    required String equipmentName,
    required String usage,
    required IconData icon,
  }) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon),
        title: Text(equipmentName),
        subtitle: Text(usage),
        trailing: ElevatedButton.icon(
          onPressed: () {
            // Handle purchase button click
          },
          icon: Icon(Icons.shopping_cart),
          label: Text('Buy Now'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SafetyGuidanceScreen(),
  ));
}
