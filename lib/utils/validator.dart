class FieldValidator {
  static String? validateEmail(String value) {
    if(value.isEmpty) return 'Enter Email!';

    final RegExp regex =
    RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)| (\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if (!regex.hasMatch(value)) {
      return 'Enter valid Email!';
    }
    return null;
  }
  static String? validatePassword(String value) {
    if(value.isEmpty) return 'Enter Password!';

    if(value.length < 9) {
      return 'Password must be more than 8 characters';
    }
    return null;
  }

}