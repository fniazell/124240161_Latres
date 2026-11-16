import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:latihan_responsi/constants/app_theme.dart';
import 'package:latihan_responsi/models/character_model.dart';
import 'package:latihan_responsi/providers/favorite_provider.dart';
import 'package:latihan_responsi/widgets/cartoon_button.dart';
import 'package:latihan_responsi/widgets/character_card.dart';
import 'package:latihan_responsi/widgets/status_badge.dart';

void main() {
  testWidgets('StatusBadge renders correct status and colors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              StatusBadge(status: 'Alive'),
              StatusBadge(status: 'Dead'),
              StatusBadge(status: 'unknown'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Alive'), findsOneWidget);
    expect(find.text('Dead'), findsOneWidget);
    expect(find.text('Unknown'), findsOneWidget);
  });

  testWidgets('CartoonButton renders label and triggers tap', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: CartoonButton(
            text: 'TEST BUTTON',
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('TEST BUTTON'), findsOneWidget);
    await tester.tap(find.text('TEST BUTTON'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('CharacterCard Favorite button is interactive and toggles state', (WidgetTester tester) async {
    final character = CharacterModel(
      id: 99,
      name: 'Morty Test',
      status: 'Alive',
      species: 'Human',
      type: '',
      gender: 'Male',
      originName: 'Earth',
      locationName: 'Earth',
      image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    );

    final favProvider = FavoriteProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<FavoriteProvider>.value(
        value: favProvider,
        child: MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 300,
              child: CharacterCard(character: character),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Morty Test'), findsOneWidget);
    // Find the favorite icon button
    final favoriteIcon = find.byIcon(Icons.favorite_border_rounded);
    expect(favoriteIcon, findsOneWidget);

    // Tap the favorite button
    await tester.tap(favoriteIcon);
    await tester.pump();

    // Verify favorite status toggled
    expect(favProvider.isFavorite(99), isTrue);
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
  });
}
