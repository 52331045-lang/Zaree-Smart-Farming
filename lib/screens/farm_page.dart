import 'package:flutter/material.dart';

import '../models/farm_data.dart';

class FarmPage extends StatefulWidget {
  const FarmPage({super.key});

  @override
  State<FarmPage> createState() => _FarmPageState();
}

class _FarmPageState extends State<FarmPage> {
  // Language
  bool isArabic = false;

  String tr(String english, String arabic) {
    return isArabic ? arabic : english;
  }

  // Text Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController detailedLocationController =
      TextEditingController();
  final TextEditingController areaController = TextEditingController();

  // Selected Options
  String? selectedCrop;
  String? selectedSoil;
  String? selectedIrrigation;

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    detailedLocationController.dispose();
    areaController.dispose();
    super.dispose();
  }

  // Language Buttons
  Widget languageButton(String label, bool arabic) {
    bool isSelected = isArabic == arabic;

    return TextButton(
      onPressed: () {
        setState(() {
          isArabic = arabic;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: isSelected
            ? const Color(0xFF24552D)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // Show Error Message
  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Crop Selection Card
  Widget buildCropCard(String crop, String arabicCrop, String emoji) {
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
                  tr(crop, arabicCrop),
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
    final farmerName = nameController.text.trim();
    final city = cityController.text.trim();
    final detailedLocation = detailedLocationController.text.trim();
    final areaText = areaController.text.trim();

    // Farmer Name Validation
    if (farmerName.isEmpty ||
        !RegExp(r'[a-zA-Z\u0600-\u06FF]').hasMatch(farmerName)) {
      showError(
        tr('Please enter a valid farmer name!', 'يرجى إدخال اسم مزارع صحيح!'),
      );
      return;
    }

    // City Validation
    if (city.isEmpty) {
      showError(
        tr(
          'Please enter your city or village!',
          'يرجى إدخال اسم المدينة أو القرية!',
        ),
      );
      return;
    }

    // Detailed Location Validation
    if (detailedLocation.isEmpty) {
      showError(
        tr(
          'Please enter your area or street!',
          'يرجى إدخال المنطقة أو الشارع!',
        ),
      );
      return;
    }

    // Land Area Validation
    if (areaText.isEmpty) {
      showError(tr('Please enter your land area!', 'يرجى إدخال مساحة الأرض!'));
      return;
    }

    final area = double.tryParse(areaText);

    if (area == null || !area.isFinite || area <= 0) {
      showError(
        tr(
          'Enter a valid positive area, such as 100 or 25.5!',
          'يرجى إدخال مساحة صحيحة مثل 100 أو 25.5!',
        ),
      );
      return;
    }

    // Crop Validation
    if (selectedCrop == null) {
      showError(tr('Please select a crop!', 'يرجى اختيار محصول!'));
      return;
    }

    // Soil Validation
    if (selectedSoil == null) {
      showError(tr('Please select soil type!', 'يرجى اختيار نوع التربة!'));
      return;
    }

    // Irrigation Validation
    if (selectedIrrigation == null) {
      showError(
        tr('Please select irrigation method!', 'يرجى اختيار طريقة الري!'),
      );
      return;
    }

    // Create FarmData Object
    final farmData = FarmData(
      farmerName: farmerName,
      country: 'Lebanon',
      city: city,
      detailedLocation: detailedLocation,
      landArea: area,
      crop: selectedCrop!,
      soilType: selectedSoil!,
      irrigationMethod: selectedIrrigation!,
    );

    // Crop Translations
    final cropNames = {
      'Tomato': tr('Tomato', 'بندورة'),
      'Potato': tr('Potato', 'بطاطا'),
      'Cucumber': tr('Cucumber', 'خيار'),
      'Lettuce': tr('Lettuce', 'خس'),
      'Pepper': tr('Pepper', 'فلفل'),
    };

    // Soil Translations
    final soilNames = {
      'Sandy Soil': tr('Sandy Soil', 'تربة رملية'),
      'Clay Soil': tr('Clay Soil', 'تربة طينية'),
      'Loamy Soil': tr('Loamy Soil', 'تربة طميية'),
    };

    // Irrigation Translations
    final irrigationNames = {
      'Drip Irrigation': tr('Drip Irrigation', 'الري بالتنقيط'),
      'Sprinkler Irrigation': tr('Sprinkler Irrigation', 'الري بالرش'),
    };

    // Successful Farm Creation
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            tr('Farm Created Successfully! 🌱', 'تم إنشاء المزرعة بنجاح! 🌱'),
          ),
          content: Text(
            '${tr('Farmer', 'المزارع')}: ${farmData.farmerName}\n'
            '${tr('Country', 'البلد')}: ${tr('Lebanon', 'لبنان')}\n'
            '${tr('City / Village', 'المدينة / القرية')}: ${farmData.city}\n'
            '${tr('Area / Street', 'المنطقة / الشارع')}: ${farmData.detailedLocation}\n'
            '${tr('Land Area', 'مساحة الأرض')}: ${farmData.landArea} m²\n'
            '${tr('Crop', 'المحصول')}: ${cropNames[farmData.crop]}\n'
            '${tr('Soil', 'التربة')}: ${soilNames[farmData.soilType]}\n'
            '${tr('Irrigation', 'الري')}: ${irrigationNames[farmData.irrigationMethod]}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(tr('OK', 'حسناً')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Zaree 🌱'),
          backgroundColor: const Color(0xFF2E7137),
          foregroundColor: Colors.white,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white54),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  languageButton('EN', false),
                  languageButton('عربي', true),
                ],
              ),
            ),
          ],
        ),
        body: Container(
          color: const Color(0xFFFFF8E9),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Description
                  Center(
                    child: Text(
                      tr('Smart Farming Assistant', 'مساعد الزراعة الذكية'),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF24552D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // My Farm Title
                  Text(
                    tr('My Farm | 🌱', 'مزرعتي | 🌱'),
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF24552D),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Farmer Name
                  Text(
                    tr('Farmer Name', 'اسم المزارع'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: tr('Enter your name', 'أدخل اسمك'),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Country
                  Text(
                    tr('Country', 'البلد'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.flag),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Align(
                      alignment: isArabic
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(tr('Lebanon', 'لبنان')),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // City / Village
                  Text(
                    tr('City / Village', 'المدينة / القرية'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: cityController,
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                    decoration: InputDecoration(
                      hintText: tr('Example: Tripoli', 'مثال: طرابلس'),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.location_city),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Detailed Location
                  Text(
                    tr('Area / Street', 'المنطقة / الشارع'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: detailedLocationController,
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                    decoration: InputDecoration(
                      hintText: tr(
                        'Example: Dam w Farez, Street name',
                        'مثال: ضم وفرز، اسم الشارع',
                      ),
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
                  Text(
                    tr('Land Area', 'مساحة الأرض'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: areaController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      hintText: tr('Enter land area', 'أدخل مساحة الأرض'),
                      suffixText: 'm²',
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
                  Text(
                    tr('Select Crop', 'اختر المحصول'),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: buildCropCard('Tomato', 'بندورة', '🍅')),
                      const SizedBox(width: 6),
                      Expanded(child: buildCropCard('Potato', 'بطاطا', '🥔')),
                      const SizedBox(width: 6),
                      Expanded(child: buildCropCard('Cucumber', 'خيار', '🥒')),
                      const SizedBox(width: 6),
                      Expanded(child: buildCropCard('Lettuce', 'خس', '🥬')),
                      const SizedBox(width: 6),
                      Expanded(child: buildCropCard('Pepper', 'فلفل', '🌶️')),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Soil Type
                  Text(
                    tr('Soil Type', 'نوع التربة'),
                    style: const TextStyle(
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
                    hint: Text(tr('Choose soil type', 'اختر نوع التربة')),
                    items: [
                      DropdownMenuItem<String>(
                        value: 'Sandy Soil',
                        child: Text(tr('Sandy Soil', 'تربة رملية')),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Clay Soil',
                        child: Text(tr('Clay Soil', 'تربة طينية')),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Loamy Soil',
                        child: Text(tr('Loamy Soil', 'تربة طميية')),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSoil = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Irrigation Method
                  Text(
                    tr('Irrigation Method', 'طريقة الري'),
                    style: const TextStyle(
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
                          title: Text(tr('Drip Irrigation', 'الري بالتنقيط')),
                          subtitle: Text(
                            tr(
                              'Water delivered directly to plant roots',
                              'يصل الماء مباشرة إلى جذور النباتات',
                            ),
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
                          title: Text(tr('Sprinkler Irrigation', 'الري بالرش')),
                          subtitle: Text(
                            tr(
                              'Water sprayed over the crops',
                              'يتم رش الماء فوق المحاصيل',
                            ),
                          ),
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
                      child: Text(
                        tr('🌱 Create My Farm', '🌱 أنشئ مزرعتي'),
                        style: const TextStyle(
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
      ),
    );
  }
}
