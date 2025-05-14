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

  static String humanReadableFormatter(
    double num, {
    int decimalDigits = 1,
    String thousandSuffix = 'K',
    String millionSuffix = 'M',
  }) {
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(decimalDigits)}$millionSuffix';
    }
    if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(decimalDigits)}$thousandSuffix';
    }
    return num.toInt().toString();
  }

  static String monthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
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

extension HumanizedFormatting on num? {
  String humanReadable({
    int decimalDigits = 1,
    String thousandSuffix = 'K',
    String millionSuffix = 'M',
  }) {
    if (this == null) return '${(0).toStringAsFixed(decimalDigits)}';

    return AppUtils.humanReadableFormatter(
      this!.toDouble(),
      decimalDigits: decimalDigits,
      thousandSuffix: thousandSuffix,
      millionSuffix: millionSuffix,
    );
  }
}

extension MonthAbrreviationFormatting on int {
  String monthAbbreviate() {
    return AppUtils.monthAbbreviation(this);
  }
}
