import 'package:flutter/material.dart';

class RegulatoryComplianceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regulatory Compliance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Regulatory Compliance in India',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'In India, the use of agrochemicals is regulated by several laws and guidelines to ensure their safe and effective application, minimize risks to human health and the environment, and promote sustainable agriculture. The key regulations governing agrochemical use in India include:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            _buildRegulationCard(
              'Insecticides Act, 1968',
              'Regulates the import, manufacture, sale, transport, distribution, and use of insecticides. Requires registration of insecticides with the Central Insecticides Board (CIB) before they can be sold or used. Mandates labeling requirements, safety measures, and adherence to prescribed usage instructions.',
            ),
            _buildRegulationCard(
              'Insecticides Rules, 1971',
              'Supplement the Insecticides Act, 1968, detailing the procedures for registration, licensing, packaging, labeling, and handling of insecticides. Prescribe the qualifications for licensing, storage, and transport regulations.',
            ),
            _buildRegulationCard(
              'Fertilizer (Control) Order, 1985',
              'Regulates the quality, price, and distribution of fertilizers. Ensures that fertilizers meet the specified standards and are properly labeled.',
            ),
            _buildRegulationCard(
              'Environmental Protection Act, 1986',
              'Provides the framework for environmental regulations, including those related to agrochemicals. Empowers the government to set standards for the discharge of environmental pollutants, including agrochemicals.',
            ),
            _buildRegulationCard(
              'Hazardous Waste (Management, Handling, and Transboundary Movement) Rules, 2016',
              'Governs the management and handling of hazardous waste, which includes certain agrochemicals. Prescribes procedures for the disposal of hazardous agrochemical waste.',
            ),
            _buildRegulationCard(
              'Central Insecticides Board & Registration Committee (CIBRC)',
              'A statutory body that evaluates the safety, efficacy, and quality of insecticides before granting registration. Issues guidelines and protocols for the safe use of pesticides.',
            ),
            _buildRegulationCard(
              'The National Policy on Integrated Pest Management (IPM)',
              'Promotes the use of biological and cultural methods of pest control alongside chemical methods. Aims to reduce the reliance on chemical pesticides and minimize their adverse effects.',
            ),
            _buildRegulationCard(
              'Food Safety and Standards Act, 2006',
              'Regulates the limits of pesticide residues in food products. Ensures that food products are safe for consumption and free from harmful levels of agrochemical residues.',
            ),
            _buildRegulationCard(
              'Bio-pesticides and Organic Farming Promotion',
              'Encourages the use of bio-pesticides and organic farming practices through various schemes and programs. Promotes sustainable agricultural practices with minimal chemical use.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegulationCard(String title, String description) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
