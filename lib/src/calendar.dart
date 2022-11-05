import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../constants/color_constants.dart';
import '../utils/calendar_utils.dart';

typedef OnDateSelected(date);

class AnimatedHorizontalCalendar extends StatefulWidget {
  final DateTime? date;
  final DateTime? initialDate;
  final DateTime? lastDate;
  final Color? textColor;
  final Color? colorOfWeek;
  final Color? colorOfMonth;
  final double? fontSizeOfWeek;
  final FontWeight? fontWeightWeek;
  final double? fontSizeOfMonth;
  final FontWeight? fontWeightMonth;
  final Color? backgroundColor;
  final Color? selectedColor;
  final int? duration;
  final Curve? curve;
  final bool? isSelected;
  final BoxShadow? selectedBoxShadow;
  final BoxShadow? unSelectedBoxShadow;
  final OnDateSelected? onDateSelected;
  final Widget? tableCalenderIcon;
  final Color? tableCalenderButtonColor;
  final ThemeData? tableCalenderThemeData;
  final bool? isInWeek;

  AnimatedHorizontalCalendar({
    Key? key,
    this.date,
    this.tableCalenderIcon,
    this.initialDate,
    this.lastDate,
    this.textColor,
    this.curve,
    this.tableCalenderThemeData,
    this.selectedBoxShadow,
    this.unSelectedBoxShadow,
    this.duration,
    this.tableCalenderButtonColor,
    this.colorOfMonth,
    this.colorOfWeek,
    this.fontSizeOfWeek,
    this.fontWeightWeek,
    this.fontSizeOfMonth,
    this.fontWeightMonth,
    this.backgroundColor,
    this.selectedColor,
    this.isSelected,
    this.isInWeek,
    @required this.onDateSelected,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<AnimatedHorizontalCalendar> {
  DateTime? _startDate;
  var selectedCalenderDate;
  double offset = 0.0;
  ScrollController? _scrollController;
  int indexs = -1;
  int currentIndex = 0;
  final scrollDirection = Axis.horizontal;
  AutoScrollController? controller;
  calenderAnimation(int index) {
    controller!.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
  }

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).size.width),
        axis: scrollDirection);
    DateTime currentDate = DateTime.now();
    selectedCalenderDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    currentIndex = currentDate.day;
    controller!.scrollToIndex(currentIndex - 1,
        preferPosition: AutoScrollPosition.begin);
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    if (dateTime.weekday == 7) {
      return dateTime;
    } else {
      if (dateTime.weekday == 1 || dateTime.weekday == 2) {}
      return dateTime.subtract(Duration(days: dateTime.weekday));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    _startDate = widget.isInWeek == false
        ? widget.date
        : findFirstDateOfTheWeek(selectedCalenderDate);

    return ListView(
        scrollDirection: scrollDirection,
        controller: controller,
        children: [
          Container(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.isInWeek == true ? 7 : daysInMonth(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    DateTime _date = _startDate!.add(Duration(days: index));

                    int diffDays =
                        _date.difference(selectedCalenderDate).inDays;

                    if (currentIndex != -1) {
                      indexs = currentIndex - 1;
                    }
                    if (widget.isSelected == true) {
                      indexs = -1;
                      calenderAnimation(0);
                    }
                    return Container(
                      child: AutoScrollTag(
                        key: ValueKey(index),
                        controller: controller!,
                        index: index,
                        child: Container(
                          width: (width - 3) * 0.1728,
                          height: 39,
                          //AppConfig().rH(11.8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: diffDays != 0
                                ? widget.backgroundColor ??
                                    ColorConstants.greyColor
                                : widget.selectedColor ?? Colors.blue,
                            //color: ColorConstants.calendarHightlightColor,
                            // color: (widget.isSelected == false &&
                            //         indexs == index)
                            //     ? ColorConstants.greenColor
                            //     : (widget.isSelected == true && indexs != index)
                            //         ? ColorConstants.textFieldFillColor
                            //         : (widget.isSelected == true &&
                            //                 indexs == index)
                            //             ? ColorConstants.greenColor
                            //             : ColorConstants.textFieldFillColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                          //ignore: deprecated_member_use
                          child: TextButton(
                            style: TextButton.styleFrom(
                              //backgroundColor: ColorConstants.calendarHightlightColor,
                              // backgroundColor: (widget.isSelected == false &&
                              //         indexs == index)
                              //     ? ColorConstants.greenColor
                              //     : (widget.isSelected == true &&
                              //             indexs != index)
                              //         ? ColorConstants.textFieldFillColor
                              //         : (widget.isSelected == true &&
                              //                 indexs == index)
                              //             ? ColorConstants.greenColor
                              //             : ColorConstants.textFieldFillColor,
                              primary: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                            ),
                            onPressed: () {
                              SchedulerBinding.instance.addPostFrameCallback(
                                  (_) => calenderAnimation(index));
                              widget.onDateSelected!(
                                  CalendarUtils.getDayOfMonth(_date));
                              setState(() {
                                indexs = index;
                                currentIndex = -1;
                                selectedCalenderDate =
                                    _startDate!.add(Duration(days: index));
                                _startDate =
                                    _startDate!.add(Duration(days: index));
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  CalendarUtils.getDayOfMonth(_date),
                                  style: TextStyle(
                                    color: diffDays != 0
                                        ? widget.colorOfMonth ??
                                            ColorConstants.darkGreyColor
                                        : Colors.white,
                                    fontSize: widget.fontSizeOfMonth ?? 18.0,
                                    fontWeight: widget.fontWeightMonth ??
                                        FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  CalendarUtils.getDayOfWeek(_date),
                                  style: TextStyle(
                                      color: diffDays != 0
                                          ? widget.colorOfWeek ??
                                              ColorConstants.darkGreyColor
                                          : Colors.white,
                                      fontSize: widget.fontSizeOfWeek ?? 12.0,
                                      fontWeight: widget.fontWeightWeek ??
                                          FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 15,
                )
              ],
            ),
          ),
        ]);
  }

  Future<DateTime?> selectDate() async {
    return await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: selectedCalenderDate,
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: widget.tableCalenderThemeData ??
              ThemeData.light().copyWith(
                primaryColor: ColorConstants.secondaryColor,
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
                colorScheme:
                    ColorScheme.light(primary: ColorConstants.secondaryColor)
                        .copyWith(secondary: ColorConstants.secondaryColor),
              ),
          child: child!,
        );
      },
      firstDate:
          widget.initialDate ?? DateTime.now().subtract(Duration(days: 30)),
      lastDate: widget.lastDate ?? DateTime.now().add(Duration(days: 30)),
    );
  }

  int daysInMonth() {
    if (widget.date != null) {
      DateTime currentDate = widget.date!;
      var firstDayThisMonth = DateTime(currentDate.year, currentDate.month, 01);
      var firstDayNextMonth = DateTime(firstDayThisMonth.year,
          firstDayThisMonth.month + 1, firstDayThisMonth.day);
      return firstDayNextMonth.difference(firstDayThisMonth).inDays;
    }
    return 0;
  }
}
