import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class Plant {
  final int id;
  final String commonName;
  final String scientificName;
  final String imageUrl;
  final String family;
  final String genus;

  Plant({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.imageUrl,
    required this.family,
    required this.genus,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      commonName: json['common_name'],
      scientificName: json['scientific_name'],
      imageUrl: json['image_url'] ?? '',
      family: json['family'],
      genus: json['genus'],
    );
  }
}

class TrefleApiService {
  final String apiKey =
      'Replace with your actual API key'; // Replace with your actual API key

  Future<List<Plant>> fetchPlants() async {
    final response = await http.get(
      Uri.parse('https://trefle.io/api/v1/plants?token=$apiKey'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)['data'];
      return jsonData.map((json) => Plant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load plants');
    }
  }
}

class PestDiseaseIdentificationScreen extends StatefulWidget {
  @override
  _PestDiseaseIdentificationScreenState createState() =>
      _PestDiseaseIdentificationScreenState();
}

class _PestDiseaseIdentificationScreenState
    extends State<PestDiseaseIdentificationScreen> {
  final TrefleApiService _trefleApiService = TrefleApiService();
  late Future<List<Plant>> _plants;

  @override
  void initState() {
    super.initState();
    _plants = _trefleApiService.fetchPlants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pest & Disease Identification'),
      ),
      body: FutureBuilder<List<Plant>>(
        future: _plants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final plants = snapshot.data!;
          return ListView.builder(
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];
              return ListTile(
                leading: plant.imageUrl.isNotEmpty
                    ? Image.network(plant.imageUrl)
                    : SvgPicture.asset('assets/placeholder.svg', width: 50),
                title: Text(plant.commonName),
                subtitle: Text(plant.scientificName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlantDetailScreen(plant: plant)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;

  PlantDetailScreen({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.commonName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scientific Name: ${plant.scientificName}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Family: ${plant.family}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Genus: ${plant.genus}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            plant.imageUrl.isNotEmpty
                ? Image.network(plant.imageUrl)
                : SvgPicture.asset('assets/placeholder.svg', width: 200),
          ],
        ),
      ),
    );
  }
}
