import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/app/home/job_entries/format.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(Format.hours(10), '10h');
    });
    test('zero', () {
      expect(Format.hours(0), '0h');
    });
    test('negative', () {
      expect(Format.hours(-5), '0h');
    });
    test('decimal', () {
      expect(Format.hours(4.5), '4.5h');
    });
  });

  group('date - US locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_US';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('08-12-2019', () {
      expect(Format.date(DateTime(2019, 8, 12)), 'Aug 12, 2019');
    });
    test('09-14-2020', () {
      expect(Format.date(DateTime(2020, 9, 14)), 'Sep 14, 2020');
    });
  });

  group('dayOfWek - US locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_US';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('Monday', () {
      expect(Format.dayOfWeek(DateTime(2019, 8, 12)), 'Mon');
    });
  });

  group('currency - US locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_US';
    });
    test('positive', () {
      expect(Format.currency(10), '\$10');
    });
    test('zero', () {
      expect(Format.currency(0), '');
    });
    test('negative', () {
      expect(Format.currency(-5), '-\$5');
    });
  });
}