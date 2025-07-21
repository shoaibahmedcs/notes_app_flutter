# Notes App with Firebase

A Flutter notes application with Google Authentication and Cloud Firestore integration.

## Features

- **Google Authentication**: Users can sign in using their Google account
- **Email/Password Authentication**: Users can create accounts and sign in with email and password
- **Account Management**: Password reset functionality for email accounts
- **Notes Management**: Create, read, update, and delete notes
- **Real-time Sync**: Notes are synchronized in real-time using Cloud Firestore
- **Material Design**: Clean and modern UI following Material Design principles
- **Responsive Layout**: Works on different screen sizes

## Project Structure

```
lib/
├── main.dart                     # App entry point and authentication wrapper
├── firebase_options.dart         # Firebase configuration (needs to be updated)
├── models/
│   └── note.dart                 # Note data model
├── screens/
│   ├── login_screen.dart         # Main authentication screen with options
│   ├── email_auth_screen.dart    # Email/password sign-in and sign-up
│   ├── home_screen.dart          # Main notes list screen
│   └── add_edit_note_screen.dart # Add/edit note screen
└── services/
    ├── auth_service.dart         # Authentication service
    └── firestore_service.dart    # Firestore database service
```

## Setup Instructions

### 1. Firebase Project Setup
Since you mentioned you already have a Firebase project set up, make sure:

- Firebase Authentication is enabled with both:
  - **Google sign-in provider**
  - **Email/Password sign-in provider**
- Cloud Firestore is set up with the following security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{noteId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

### 2. Firebase Configuration
Update the `firebase_options.dart` file with your actual Firebase configuration values:

1. Install Firebase CLI: `npm install -g firebase-tools`
2. Run: `flutter pub global activate flutterfire_cli`
3. Run: `flutterfire configure` (this will automatically generate the correct firebase_options.dart)

Or manually update the values in `lib/firebase_options.dart` with your project's configuration from the Firebase Console.

### 3. Google Sign-In Setup

#### Android
Make sure your `google-services.json` file is in the correct location: `android/app/google-services.json`

#### iOS (if needed)
1. Add `GoogleService-Info.plist` to `ios/Runner/`
2. Update `ios/Runner/Info.plist` with URL scheme

### 4. Run the App

```bash
flutter pub get
flutter run
```

## Usage

1. **Sign In**: Tap "Sign in with Google" to authenticate
2. **Create Note**: Tap the + button to create a new note
3. **Edit Note**: Tap on any note to edit it
4. **Delete Note**: Use the menu button (⋮) on each note card to delete
5. **Sign Out**: Use the profile menu in the top-right corner

## Features Breakdown

### Authentication (AuthService)
- Google Sign-In integration
- Real-time authentication state monitoring
- Secure sign-out functionality

### Notes Management (FirestoreService)
- CRUD operations for notes
- Real-time data synchronization
- User-specific data isolation

### UI Components
- **Login Screen**: Beautiful gradient background with Google sign-in button
- **Home Screen**: Grid/list view of notes with search and filter options
- **Add/Edit Screen**: Rich text editor for note content
- **Navigation**: Smooth transitions between screens

### Data Model (Note)
Each note contains:
- `id`: Unique identifier
- `title`: Note title
- `body`: Note content
- `userId`: Owner's user ID
- `createdAt`: Creation timestamp
- `updatedAt`: Last modification timestamp

## Security

- All notes are private to the authenticated user
- Firestore security rules prevent unauthorized access
- Authentication state is properly managed

## Next Steps

You can extend this app by adding:
- Rich text formatting
- Image attachments
- Categories/tags
- Search functionality
- Offline support
- Note sharing
- Voice notes
- Dark theme

## Troubleshooting

If you encounter issues:
1. Make sure all Firebase services are enabled in your Firebase Console
2. Verify that `google-services.json` is in the correct location
3. Check that Firestore security rules are properly configured
4. Ensure your SHA-1 fingerprint is registered in Firebase Console for Google Sign-In
