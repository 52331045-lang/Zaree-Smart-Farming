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

  // Crop Selection Card
  Widget buildCropCard(String crop, String emoji) {
    bool isSelected = selectedCrop == crop;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCrop = crop;
        });
      },
      child: Container(
        height: 105,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0EDCC) : const Color(0xFFFFF5DF),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2E7137)
                : const Color(0xFFD8CBA8),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 27)),
                const SizedBox(height: 6),
                Text(
                  crop,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (isSelected)
              const Positioned(
                top: 3,
                right: 3,
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFF2E7137),
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Create Farm Function
  void createFarm() {
    if (nameController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty ||
        areaController.text.trim().isEmpty ||
        selectedCrop == null ||
        selectedSoil == null ||
        selectedIrrigation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all farm information!')),
      );
      return;
    }

    final area = double.tryParse(areaController.text.trim());

    if (area == null || area <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid land area!')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Farm Created Successfully! 🌱'),
          content: Text(
            'Farmer: ${nameController.text}\n'
            'Location: ${locationController.text}\n'
            'Land Area: ${areaController.text} m²\n'
            'Crop: $selectedCrop\n'
            'Soil: $selectedSoil\n'
            'Irrigation: $selectedIrrigation',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
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
        title: const Text('Zaree 🌱'),
        backgroundColor: const Color(0xFF2E7137),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFFFFF8E9),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Smart Farming Assistant',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF24552D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'My Farm | أرضي 🌱',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF24552D),
                  ),
                ),
                const SizedBox(height: 20),

                // Farmer Name
                const Text(
                  'Farmer Name | اسم المزارع',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),

                // Location
                const Text(
                  'Location | الموقع',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    hintText: 'Enter your location',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 20),

                // Land Area
                const Text(
                  'Land Area | مساحة الأرض',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: areaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter land area in m²',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.landscape),
                  ),
                ),
                const SizedBox(height: 20),

                // Crop Selection
                const Text(
                  'Select Crop | اختر المحصول',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: buildCropCard('Tomato', '🍅')),
                    const SizedBox(width: 6),
                    Expanded(child: buildCropCard('Potato', '🥔')),
                    const SizedBox(width: 6),
                    Expanded(child: buildCropCard('Cucumber', '🥒')),
                    const SizedBox(width: 6),
                    Expanded(child: buildCropCard('Lettuce', '🥬')),
                    const SizedBox(width: 6),
                    Expanded(child: buildCropCard('Pepper', '🌶️')),
                  ],
                ),
                const SizedBox(height: 20),

                // Soil Type
                const Text(
                  'Soil Type | نوع التربة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF24552D),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedSoil,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.terrain),
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
                const Text(
                  'Irrigation Method | طريقة الري',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF24552D),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5DF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD8CBA8)),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        value: 'Drip Irrigation',
                        groupValue: selectedIrrigation,
                        activeColor: const Color(0xFF2E7137),
                        title: const Text('Drip Irrigation'),
                        subtitle: const Text(
                          'Water delivered directly to plant roots',
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedIrrigation = value;
                          });
                        },
                      ),
                      const Divider(),
                      RadioListTile<String>(
                        value: 'Sprinkler Irrigation',
                        groupValue: selectedIrrigation,
                        activeColor: const Color(0xFF2E7137),
                        title: const Text('Sprinkler Irrigation'),
                        subtitle: const Text('Water sprayed over the crops'),
                        onChanged: (value) {
                          setState(() {
                            selectedIrrigation = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Create My Farm Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: createFarm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7137),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      '🌱 Create My Farm | إنشاء أرضي',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
