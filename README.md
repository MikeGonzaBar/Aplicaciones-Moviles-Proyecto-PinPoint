# PinPoint 📍

A location-based social media app built with Flutter that allows users to discover and share messages near their current location.

## 🌟 Features

### Core Functionality
- **Location-based Posts**: Share messages that are tied to your current GPS location
- **Proximity Filtering**: Filter posts by distance ranges:
  - Close to you (nearby)
  - 500m - 1km
  - 1km - 2km
  - All posts
- **Anonymous Posting**: Option to publish posts anonymously
- **Temporary Posts**: Set post expiration (1, 7, or 15 days)
- **Image Support**: Attach images to your posts
- **Real-time Feed**: Pull-to-refresh functionality for latest content

### User Experience
- **Modern UI**: Clean, intuitive interface with Material Design
- **Authentication**: Firebase-based user authentication
- **Comment System**: Engage with posts through comments
- **Personal Posts**: View and manage your own posts
- **Share Functionality**: Share posts with other apps

## 🛠 Tech Stack

- **Framework**: Flutter (Dart)
- **Backend**: Firebase
  - Authentication (Firebase Auth)
  - Database (Cloud Firestore)
  - Storage (Firebase Storage)
- **State Management**: Provider pattern
- **Location Services**: Geolocator
- **UI Components**: Material Design with Google Fonts
- **Image Handling**: File Picker


## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=2.18.2)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/pinpoint.git
   cd pinpoint
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication, Firestore, and Storage
   - Download and add the configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── items/                 # Reusable UI components
│   ├── comment_item.dart
│   ├── end_of_scroll_item.dart
│   └── post_item.dart
├── pages/                 # Main app screens
│   ├── comment_section.dart
│   ├── feed.dart
│   ├── login.dart
│   ├── main_page.dart
│   ├── my_posts.dart
│   ├── new_post.dart
│   └── register.dart
├── providers/             # State management
│   ├── comments_provider.dart
│   ├── images_provider.dart
│   ├── posts_provider.dart
│   └── users_provider.dart
├── widgets/               # Custom widgets
│   └── time_distance_text.dart
└── main.dart             # App entry point
```

## 🔧 Configuration

### Environment Setup
- Ensure location permissions are granted on the device
- Configure Firebase project settings
- Set up proper API keys and security rules

### Dependencies
Key dependencies include:
- `firebase_core`, `firebase_auth`, `cloud_firestore` - Firebase services
- `geolocator` - Location services
- `provider` - State management
- `google_fonts` - Typography
- `file_picker` - Image selection
- `timeago` - Time formatting

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🙏 Acknowledgments

- Built for ITESO Mobile Applications course
- Inspired by location-based social platforms
- Uses Firebase for robust backend services

---

**PinPoint** - Connect with your surroundings, one location at a time! 📍
