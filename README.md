# ARIA — AI Personal Secretary

## Setup Instructions

### 1. Clone the repo
```bash
git clone https://github.com/yourusername/aria-flutter-app.git
cd aria-flutter-app
```

### 2. Create your `.env` file
Create a `.env` file in the project root:
```
GROQ_API_KEY=your_groq_api_key_here
```
Get your free Groq API key from: https://console.groq.com

### 3. Add Firebase config files
- Get `google-services.json` from Firebase Console → Project Settings → Android app
- Place it in `android/app/google-services.json`
- Run `flutterfire configure --project=aria-secretary-11bb6`

### 4. Install dependencies
```bash
flutter pub get
```

### 5. Generate Drift database code
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. Run the app
```bash
flutter run -d android
```