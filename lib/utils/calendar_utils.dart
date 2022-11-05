import 'package:intl/intl.dart';

class CalendarUtils {
  static String getDayOfWeek(DateTime date) => DateFormat('EEE').format(date);

  static String getDayOfMonth(DateTime date) => DateFormat('dd').format(date);

  static String getDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  static String getExactDate(String date) => DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date));

  static String getUSFormatDate(String date) => DateFormat('MM-dd-yyyy').format(DateFormat("yyyy-MM-dd").parse(date));

  static String getBackEndFormatDate(String date) => DateFormat("yyyy-MM-dd").format(DateFormat('MM-dd-yyyy').parse(date));

  static String getExactDateInString(String date) => DateFormat('dd').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date));

  static String getExactMonthInString(String date) => DateFormat('MM').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date));

  static String getDates(String date) => DateFormat("d MMM").format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date));

  static String getTime(String date) => DateFormat("hh:mm a").format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date));

  static String getDateTimeForImage(DateTime date) => DateFormat("yyyy-MM-ddTHH:mm").format(date);

  static String getEDate(String date) => DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date));

}