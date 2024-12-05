// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class OnGoogleLogin extends LoginEvent {
  final BuildContext context;

  OnGoogleLogin({required this.context});
  @override
  List<Object> get props => [context];
}

class OnGoogleLogout extends LoginEvent {
  final BuildContext context;

  OnGoogleLogout({required this.context});
}

class OnCheckLogin extends LoginEvent {
  final BuildContext context;

  OnCheckLogin({required this.context});
}

class OnEmailLogin extends LoginEvent {
  String email;
  final BuildContext context;
  String password;
  OnEmailLogin(
    this.context, {
    required this.email,
    required this.password,
  });
}

class OnEmailSignUp extends LoginEvent {
  final BuildContext context;
  String email;
  String password;
  OnEmailSignUp({
    required this.context,
    required this.email,
    required this.password,
  });
}
