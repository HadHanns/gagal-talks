# Gagal Talks

A supportive Flutter platform where users can share their failure stories and lessons learned. The app focuses on empathy, sharing, and learning from failure. No login required (guest mode).

## Features

- **Story Model:**
  - Fields: id, title, content, lesson, category, isAnonymous, date, likes
- **Home Screen:**
  - List of stories with title, excerpt, and category
  - Tap to view story details
- **Story Detail Screen:**
  - Full content, lesson learned
  - Anonymous option hides user name
  - Like button (disabled, shows snackbar: "Login required to like")
- **Add Story Screen:**
  - Form to input title, content, lesson, category, and anonymous switch
  - Submit adds story to local list (no backend)
- **State Management:**
  - Uses Provider + ChangeNotifier
  - In-memory data with dummy stories
- **Theme & UI:**
  - Warm colors: light orange, soft blue, beige
  - Friendly, clean Material 3 UI

## Getting Started

1. **Clone the repository:**
   ```sh
   git clone <your-repo-url>
   cd gagal_talks
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Run the app:**
   ```sh
   flutter run
   ```

## Dependencies
- [provider](https://pub.dev/packages/provider)
- [uuid](https://pub.dev/packages/uuid)

## Screenshots
_Add your screenshots here_

## License
MIT
