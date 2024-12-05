import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  final ImagePicker picker = ImagePicker();
  final firebase_storage.FirebaseStorage myStorage =
      firebase_storage.FirebaseStorage.instance;

  ImagePickerCubit() : super(ImagePickerInitial());

  Future<void> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 100);
      if (pickedFile != null) {
        emit(ImagePickerPicked(myFile: File(pickedFile.path)));
      } else {
        emit(ImagePickerInitial());
        if (kDebugMode) {
          print('no file selected');
        }
      }
    } catch (e) {
      emit(ImagePickerInitial());
      if (kDebugMode) {
        print('Error picking image: $e');
      }
    }
  }

  Future<String> uploadImage(File? file) async {
    if (file == null) {
      throw ArgumentError('File is null');
    } else {
      String filename = DateTime.now().millisecondsSinceEpoch.toString();
      try {
        firebase_storage.Reference reference =
            myStorage.ref().child('foods/$filename.jpg');

        await reference.putFile(file);
        String downloadUrl = await reference.getDownloadURL();

        return downloadUrl;
      } on firebase_storage.FirebaseException catch (e) {
        if (kDebugMode) {
          print('Firebase storage error: $e');
        }
        rethrow;
      } catch (e) {
        if (kDebugMode) {
          print('Error uploading image: $e');
        }
        return '';
      }
    }
  }
}
