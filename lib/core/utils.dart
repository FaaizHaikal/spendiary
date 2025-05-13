import 'package:intl/intl.dart';

class AppUtils {
  static NumberFormat _idrFormatter({
    int decimalDigits = 2,
    String symbol = 'Rp. ',
  }) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
  }
}

extension CurrencyFormatting on num? {
String toIDR({
    int decimalDigits = 2,
    String symbol = 'Rp. ',
    bool compact = false,
    String fallback = '-',
  }) {
    if (this == null) return fallback;
    return this!.toIDR(
      decimalDigits: decimalDigits,
      symbol: symbol,
      compact: compact,
    );
  }
}
