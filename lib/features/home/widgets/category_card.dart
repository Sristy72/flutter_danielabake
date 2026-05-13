import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color bgColor;
  final VoidCallback? onTap; //added

  const CategoryCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.bgColor,
    this.onTap, //added
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, //added
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6), // adjust radius as needed
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fill,
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
