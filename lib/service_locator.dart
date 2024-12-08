import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'core/preferences/preferences.dart';

final sl = GetIt.instance; // Service locator instance.

/// Sets up the service locators for Firebase and app services.
setupLocators() async {
  // Firebase Authentication instance for user authentication.
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Firestore instance for database operations.
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Google Sign-In instance for handling authentication via Google.
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // Preferences singleton for managing user settings.
  sl.registerSingleton<Preferences>(Preferences.instance);
}
