import 'package:bionic/common/title_heading.dart';
import 'package:bionic/constants/app_assets.dart';
import 'package:bionic/constants/app_colors.dart';
import 'package:bionic/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Notes extends StatelessWidget {
  const Notes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        flexibleSpace: SvgPicture.asset(
          AppAssets.wavePurple,
          fit: BoxFit.cover,
        ),
        toolbarHeight: MediaQuery.maybeSizeOf(context)!.height * 0.16,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const TitleHeading(title: AppConstants.notes),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                mainAxisExtent: 140,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                return NoteCard(
                  index: index + 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final int index;
  const NoteCard({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.yellow,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title $index',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '$index Description ',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            right: 11,
            child: Container(
              width: 42.0,
              height: 42.0,
              decoration: const BoxDecoration(
                color: AppColors.purpleColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '1$index +',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
