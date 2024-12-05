// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'image_picker_cubit.dart';

class ImagePickerState extends Equatable {
  @override
  List<Object> get props => [];
}

final class ImagePickerInitial extends ImagePickerState {}

final class ImagePickerPicked extends ImagePickerState {
  final File myFile;

  ImagePickerPicked({
    required this.myFile,
  });
  @override
  List<Object> get props => [myFile];
}
