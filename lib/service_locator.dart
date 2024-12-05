import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'core/preferences/preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

setupLocators() async {
  //  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerSingleton<Preferences>(Preferences.instance);

  // login Injection Container
  // LoginInjectionContainer().register();
}
