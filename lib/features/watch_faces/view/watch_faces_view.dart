import 'package:flutter/material.dart';
import 'package:wrist_sync/core/constants/home_design.dart';
import 'package:wrist_sync/core/widgets/app_header.dart';
import 'package:wrist_sync/features/home/widgets/app_bottom_bar.dart';
import 'package:wrist_sync/features/home/widgets/watch_face_card.dart';

class WatchFacesView extends StatelessWidget {
  const WatchFacesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppHeader(title: 'Watch Faces'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find your style',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Explore face concepts for your next watch look.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 20,
                children: [
                  for (final face in watchFaceCatalog)
                    WatchFaceCard(
                      face: face,
                      onTap: () => _showPreview(context, face),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: theme.brightness == Brightness.dark
                      ? const LinearGradient(
                          colors: [Color(0xFF1B3443), Color(0xFF282D49)],
                        )
                      : HomeDesign.helpGradient,
                  borderRadius: BorderRadius.circular(HomeDesign.cardRadius),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'These are previews. Installing faces requires watch support that is not available yet.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomBar(selectedIndex: 1),
    );
  }

  void _showPreview(BuildContext context, WatchFaceData face) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(face.name),
        content: const Text(
          'This face is a visual preview. Applying watch faces is not supported yet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
