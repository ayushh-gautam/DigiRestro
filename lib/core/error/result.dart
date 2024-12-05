
import 'failure.dart';

class Result<T> {
  T? _value;
  AppErrorHandler? _error;

  Result.value(T value) {
    _value = value;
  }

  Result.error(AppErrorHandler error) {
    _error = error;
  }

  T? get value => _value;
  AppErrorHandler? get error => _error;

  bool get isValue => _value != null;
  bool get isError => _error != null;
}
