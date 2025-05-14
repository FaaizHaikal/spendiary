import 'package:intl/intl.dart';

class AppUtils {
  static NumberFormat _idrFormatter({
    int decimalDigits = 2,
    String symbol = 'Rp. ',
    bool compact = false,
  }) {
    return compact
        ? NumberFormat.compactCurrency(
          locale: 'id_ID',
          symbol: symbol,
          decimalDigits: decimalDigits,
        )
        : NumberFormat.currency(
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
    return AppUtils._idrFormatter(
      decimalDigits: decimalDigits,
      symbol: symbol,
      compact: compact,
    ).format(this!); // Format directly using the formatter
  }
}
