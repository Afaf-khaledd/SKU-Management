class InputValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Branch name is required';
    }
    return null;
  }

  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    return null;
  }

  static String? validateManagerName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Manager name is required';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 11) {
      return 'Phone number must be at least 11 characters';
    }
    return null;
  }

  static String? validateItemName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Item name is required';
    }
    return null;
  }
  static String? validateItemBrand(String? value) {
    if (value == null || value.isEmpty) {
      return 'Item brand is required';
    }
    return null;
  }
  static String? validateItemCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Item code is required';
    }
    final RegExp regExp = RegExp(r'^SKU(\d{1,6})$');
    if (!regExp.hasMatch(value)) {
      return 'Code must start with "SKU" followed by numbers (0-999)';
    }
    return null;
  }

}
