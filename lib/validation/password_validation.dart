import 'package:formz/formz.dart';

enum PasswordValidatorValidationError {
  empty,
  tooShort,
  noUpperCase,
  noLowerCase,
  noDigit,
  noSpecialChar
}

class PasswordValidator
    extends FormzInput<String, PasswordValidatorValidationError>
    with FormzInputErrorCacheMixin {
  PasswordValidator.pure([super.value = '']) : super.pure();
  PasswordValidator.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidatorValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidatorValidationError.empty;
    } else if (value.length < 8) {
      return PasswordValidatorValidationError.tooShort;
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return PasswordValidatorValidationError.noUpperCase;
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return PasswordValidatorValidationError.noLowerCase;
    } else if (!RegExp(r'\d').hasMatch(value)) {
      return PasswordValidatorValidationError.noDigit;
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return PasswordValidatorValidationError.noSpecialChar;
    }
    return null;
  }
}

enum ConfirmPasswordValidatorValidationError { empty, mismatch }

class ConfirmPasswordValidator
    extends FormzInput<String, ConfirmPasswordValidatorValidationError> {
  final String password;

  const ConfirmPasswordValidator.pure({this.password = '', String value = ''})
      : super.pure(value);
  const ConfirmPasswordValidator.dirty(
      {required this.password, required String value})
      : super.dirty(value);

  @override
  ConfirmPasswordValidatorValidationError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmPasswordValidatorValidationError.empty;
    } else if (value != password) {
      return ConfirmPasswordValidatorValidationError.mismatch;
    }
    return null;
  }
}
