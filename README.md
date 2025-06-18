# GagalTalks

A supportive Flutter platform where users can share their failure stories and lessons learned. The app focuses on empathy, sharing, and learning from failure. No login required (guest mode).

---

## Features

- **Story Model:**
  - Fields: id, title, content, lesson, category, isAnonymous, date, likes, replyCount
- **Home Screen:**
  - List of stories with title, excerpt, category, and real-time reply count
  - Tap to view story details
- **Story Detail Screen:**
  - Full content, lesson learned, and all replies (real-time updates)
  - Anonymous option hides user name
  - Like/unlike button (one like per device, togglable)
  - Add and view replies in real-time
- **Add Story Screen:**
  - Form to input title, content, lesson, category, and anonymous switch
  - Submit adds story to Firestore
- **Replies:**
  - Replies are stored in a separate Firestore collection and shown in real-time
  - Reply count is denormalized for performance and consistency
- **State Management:**
  - Uses Provider + ChangeNotifier
- **Theme & UI:**
  - Warm, friendly Material 3 UI with custom colors and Google Fonts
  - Responsive AppBar with centered logo and title

---

## Firebase Setup

1. **Create a Firebase project** at [Firebase Console](https://console.firebase.google.com/).
2. **Add Android and iOS apps** to your Firebase project.
3. **Download `google-services.json`** (Android) and place it in `android/app/`.
4. **Download `GoogleService-Info.plist`** (iOS) and place it in `ios/Runner/`.
5. **Enable Firestore** in the Firebase Console.
6. **Firestore Structure:**
   - `stories` collection: Each document is a story, with a `replyCount` field.
   - `replies` collection: Each document is a reply, with a `storyId` field referencing its story.
7. **(Optional) Update Firestore Security Rules** for your use case.

---

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

---

## Dependencies

- [provider](https://pub.dev/packages/provider)
- [uuid](https://pub.dev/packages/uuid)
- [firebase_core](https://pub.dev/packages/firebase_core)
- [cloud_firestore](https://pub.dev/packages/cloud_firestore)
- [google_fonts](https://pub.dev/packages/google_fonts)
- [shared_preferences](https://pub.dev/packages/shared_preferences)

---

## Project Structure

- `lib/models/` - Data models for Story and Reply
- `lib/providers/` - State management (Provider)
- `lib/screens/` - UI screens (Home, Add Story, Story Detail)
- `lib/managers/` - Local managers (e.g., liked stories)
- `assets/` - App images and logo

---

## Screenshots

_Add your screenshots here_

---

## License

MIT
