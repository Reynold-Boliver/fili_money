import 'package:formz/formz.dart';

enum EmailValidationError { invalid, empty }

class EmailValidator extends FormzInput<String, EmailValidationError>
    with FormzInputErrorCacheMixin {
  EmailValidator.pure([super.value = '']) : super.pure();

  EmailValidator.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}
