import 'package:flutter/material.dart';

class FarmPage extends StatefulWidget {
  const FarmPage({super.key});

  @override
  State<FarmPage> createState() => _FarmPageState();
}

class _FarmPageState extends State<FarmPage> {
  // Text Controllers
  final TextEditingController nameController = TextEditingController();

  final TextEditingController locationController = TextEditingController();

  final TextEditingController areaController = TextEditingController();

  // Selected Options
  String? selectedCrop;
  String? selectedSoil;
  String? selectedIrrigation;

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: const Text('My Farm 🌱'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      // Body
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Farmer Information',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Farmer Name
              const Text('Farmer Name'),

              const SizedBox(height: 8),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 20),

              // Location
              const Text('Location'),

              const SizedBox(height: 8),

              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  hintText: 'Enter your location',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),

              const SizedBox(height: 20),

              // Land Area
              const Text('Land Area'),

              const SizedBox(height: 8),

              TextField(
                controller: areaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter land area in m²',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.landscape),
                ),
              ),

              const SizedBox(height: 20),

              // Crop Selection
              const Text('Select Crop'),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: selectedCrop,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.grass),
                ),
                hint: const Text('Choose your crop'),

                items:
                    [
                      'Tomato',
                      'Potato',
                      'Cucumber',
                      'Lettuce',
                      'Pepper',
                      'Apple',
                    ].map((crop) {
                      return DropdownMenuItem<String>(
                        value: crop,
                        child: Text(crop),
                      );
                    }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedCrop = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Soil Type
              const Text('Soil Type'),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: selectedSoil,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.terrain),
                ),
                hint: const Text('Choose soil type'),

                items: ['Sandy Soil', 'Clay Soil', 'Loamy Soil'].map((soil) {
                  return DropdownMenuItem<String>(
                    value: soil,
                    child: Text(soil),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedSoil = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Irrigation Method
              const Text('Irrigation Method'),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: selectedIrrigation,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.water_drop),
                ),
                hint: const Text('Choose irrigation method'),
                items: ['Drip Irrigation', 'Sprinkler Irrigation'].map((
                  method,
                ) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedIrrigation = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
