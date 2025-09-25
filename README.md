# F1 App (Flutter)

<p align="center">
  <img src="assets/imags/f1_logo_lanch_app.jpg" alt="App Logo" width="180" />
</p>

<p align="center">
  <img src="assets/imags/demo.gif" alt="App Demo" width="360" />
</p>

A simple, production‑ready Flutter app that shows:
- F1 Drivers list (with team colors and avatars)
- Latest F1 News (cards + detail screen without WebView)
- Podium/Standings tab (race title, time, track + ordered standings)

The app is RTL‑friendly for Arabic content and includes robust error/empty states.

## Features

- F1 Drivers
  - Fetches drivers from OpenF1 and renders with team colors and images
  - Efficient list rendering via `ListView.builder`

- F1 News
  - Fetches news from NewsAPI
  - Card UI with image, title, source and date
  - Detail screen inside the app (no WebView): shows description/content
  - If full content is missing, falls back to HTML scraping (best‑effort)

- Podium / Standings
  - Fetches Google Sports results via SerpAPI
  - Shows series title (e.g., Formula 1), race title, date/time and track
  - Renders ordered standings list with position, driver, team, grid, and laptime

- Polished UX
  - `FlashyTabBar` bottom navigation (Drivers / News / Podium)
  - Image placeholders and network error handling
  - RTL layout for Arabic text via `Directionality`

## Architecture & Structure

```
lib/
  const/
    String.dart                // API endpoints and keys
  Models/
    drivers_model.dart         // Driver model (OpenF1)
    Articlesmodle.dart         // News article model
    podium_models.dart         // Podium/standings models
  Services/
    f1_api_cal.dart            // API client (Dio): drivers, news, podium, HTML scraping
  Screen/
    home.dart                  // Main screen with bottom tabs
    news_f1_.dart              // News list screen
    news_details.dart          // News detail screen (in‑app content)
    podium_screen.dart         // Podium/standings screen
  Widgets/
    Drivers_widget.dart        // Driver list item
    News_F1.dart               // News card widget
  main.dart                    // App bootstrap (creates ApiService and routes to Home)
assets/
  imags/                       // Images and SVGs
```

## Data Layer (APIs & Sources)

- OpenF1 (Drivers)
  - Endpoint: set in `Strings.api_f1_drivers`
  - Example: `https://api.openf1.org/v1/drivers?session_key=9158`

- NewsAPI (F1 News)
  - Endpoint: set in `Strings.api_f1_news`
  - Requires API key; replace with your own if needed
  - The service parses articles: image, title, description, source name, date, url, content

- SerpAPI (Google Sports – Podium/Standings)
  - Endpoint: set in `Strings.api_f1_podiom`
  - Parses `sports_results.tables.results` to extract:
    - series title (Formula 1)
    - race title (e.g., Azerbaijan GP)
    - date/time (e.g., tomorrow, 7:00 AM)
    - track name (e.g., Baku City Circuit)
    - standings array with driver, team, vehicle number, grid, qual_time

- HTML Scraping (Full News Content)
  - Implemented in `ApiService.fetchFullArticleContent(url)` using the `html` package
  - Strategy: parse HTML, prefer `<article>` then all `<p>` nodes, join text
  - Best‑effort: some sites may block scraping or structure content differently

## UI Layer – Key Widgets Used

- `Scaffold`, `AppBar`
- `FlashyTabBar` (from `flashy_tab_bar2`) for bottom navigation
- `FutureBuilder` for async states
- `ListView.builder`, `ListView.separated` for lists
- `Card`, `ListTile`, `CircleAvatar`
- `Image.network` with `errorBuilder` and placeholders
- `ClipRRect`, `Padding`, `SizedBox`
- `InkWell` for taps and navigation
- `SvgPicture` (from `flutter_svg`) for SVG icons
- `Directionality` to force RTL where needed
- `SnackBar` for lightweight feedback

## Dependencies

- Networking & Parsing: `dio`, `html`
- Navigation bar: `flashy_tab_bar2`
- Assets & Icons: `flutter_svg`, `cupertino_icons`
- Utils: `url_launcher` (optional external open), `flutter_lints`

See `pubspec.yaml` for exact versions.

## How It Works (per Tab)

- Drivers tab
  - `Home` builds a `FutureBuilder` on `ApiService.getDrivers()`
  - Renders each driver via `DriversWidget` with team color, name, image

- News tab
  - `news_f1_.dart` loads `ApiService.getF1news()` and shows a list of `NewsF1_wedgit`
  - On tap: navigates to `NewsDetailsScreen`
  - Details: shows title, metadata, description, and content; if content is empty, calls `fetchFullArticleContent(url)` and displays the parsed text

- Podium tab
  - `PodiumScreen` calls `ApiService.getPodium()` and displays event header + ordered standings

## Configuration

Edit `lib/const/String.dart` to set/replace API endpoints and keys:
- `api_f1_drivers`: OpenF1 endpoint
- `api_f1_news`: NewsAPI endpoint (+ your API key)
- `api_f1_podiom`: SerpAPI endpoint (+ your API key)

Important: store keys securely for production (e.g., use remote config, server proxy, or secrets management). Keys in source are for demo/dev only.

## Permissions

- Android: INTERNET permission is enabled (release + debug) to fetch remote data.

## Getting Started

Prerequisites:
- Flutter SDK and Dart (see `environment` in `pubspec.yaml`, Dart SDK `^3.9.2`)
- A connected device or emulator

Install dependencies:
```
flutter pub get
```

Run the app:
```
flutter run
```

Build APK (Android):
```
flutter build apk --release
```

## Known Limitations

- Some news sites may block scraping or require JS rendering; the fallback extractor is best‑effort.
- External APIs can change response shape; the parser defensively handles missing fields but may need updates.

## Roadmap / Ideas

- Pull‑to‑refresh on lists
- Persist last fetched items for offline viewing
- Theming (dark mode), typography polish
- Add driver details screen and race schedule
