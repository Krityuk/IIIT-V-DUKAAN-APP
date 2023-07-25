// import 'package:intl/intl.dart';
// The intl package is a powerful library that provides various classes and utilities for formatting dates, numbers, currencies,
// and messages according to different locales.

import 'package:intl/intl.dart';

String? validateEmail(value, isValid) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  if (value.isNotEmpty && isValid == false) {
    return 'Please, enter a valid email';
  }
  return null;
}

// String? validatePassword(value, pswd) {
//   if (pswd.isNotEmpty) {
//     if (value.isEmpty || value == null) {
//       //  MUJHE YE IMPROPER LAG RHA
//       return 'Please enter password';
//     }
//     if (value.length < 6) {
//       return 'Password is too small';
//     }
//   }
//   return null;
// }

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }

  if (value.length < 6) {
    return 'Password should be at least 6 characters long';
  }

  return null; // Return null if the password is valid
}

//*********************************************************** */
String? checkNullEmptyValidation(value, title) {
  if (value == null || value.isEmpty) {
    return 'Please enter your $title ';
  }
  return null;
}

String? validateSamePassword(value, password) {
  if (value != password) {
    return 'Confirm password must be same as password';
  } else if (value.isEmpty && password.isEmpty) {
    return null;
  } else if (value == null || value.isEmpty) {
    return 'Please enter confirm password';
  }

  return null;
}

String? validateMobile(value) {
  String? checkNullEmpty = checkNullEmptyValidation(value, "phone number");
  if (checkNullEmpty != null) {
    return checkNullEmpty;
  }
  if (value.length != 10) {
    return 'Please enter a valid mobile number';
  }
  return null;
}
//*********************************************************** */

intToStringFormatter(value) {
  NumberFormat numberFormat = NumberFormat("##,##,##0");
  var parse = int.parse(value);
  var formattedValue = numberFormat.format(parse);
  return formattedValue;
}

formattedTime(value) {
  var date = DateTime.fromMicrosecondsSinceEpoch(value);
  var formattedDate = DateFormat.yMMMd().format(date);
  return formattedDate;
}

