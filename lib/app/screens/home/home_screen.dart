import 'package:flutter/material.dart';
import 'package:sauna_krystal/app/widgets/booking_modal.dart';
import 'package:sauna_krystal/app/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Krystal Sauna',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_pin, color: Colors.black),
                        Text(
                          'ул. Абая 55',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomButton(
                        text: 'Забронировать',
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (BuildContext context) {
                              return BookingModal();
                            },
                          );
                        }),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.black),
                        Text(
                          '+7 747-541-98-77',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Image with overlay
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              'https://zolotoy-kolos.com/upload/iblock/859/859b13b869c8606b1f27531739e7e98c.jpg',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        top: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Cryhsta Sauna',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Премиальный отдых для вас и вашей компании.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Features Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Преимущества Krystal Sauna',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Sauna features with titles and descriptions
                        _buildFeatureItem(
                          icon: Icons.pool,
                          title: 'Бассейн',
                          description:
                              'Большой бассейн для расслабляющего отдыха.',
                        ),
                        _buildFeatureItem(
                          icon: Icons.music_note,
                          title: 'Караоке',
                          description: 'Пойте ваши любимые песни с друзьями.',
                        ),
                        _buildFeatureItem(
                          icon: Icons.sports_esports,
                          title: 'Игры',
                          description: 'Настольные игры для всех возрастов.',
                        ),
                        _buildFeatureItem(
                          icon: Icons.house_siding,
                          title: 'Большая площадь',
                          description:
                              'Просторное пространство для вашего комфорта.',
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: CustomButton(
                                text: 'Забронировать',
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.white,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    builder: (BuildContext context) {
                                      return BookingModal();
                                    },
                                  );
                                })),
                        // Package Pricing Section
                        SizedBox(height: 24),
                        Text(
                          'Цены на пакеты',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildPricingPackage(
                          packageName: 'Дневной пакет',
                          price: '6000 тг/час',
                          details: 'До 17:00. От 8 человек 1000тг за человека.',
                          backgroundColor:
                              const Color.fromARGB(255, 238, 238, 238),
                          textColor: Colors.black87,
                        ),
                        _buildPricingPackage(
                          packageName: 'Вечерной пакет',
                          price: '8000 тг/час',
                          details:
                              'После 17:00. От 8 человек 1000тг за человека.',
                          backgroundColor:
                              const Color.fromARGB(255, 48, 48, 48),
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  // Contact Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Контактная информация',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.map,
                              size: 100,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.location_pin, color: Colors.black),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'ул. Абая 55, Krystal Sauna',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.phone, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              '+7 747-541-98-77',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable widget for each feature with title and description
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reusable widget for package pricing information with customizable colors
  Widget _buildPricingPackage({
    required String packageName,
    required String price,
    required String details,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            packageName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 4),
          Text(
            details,
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
