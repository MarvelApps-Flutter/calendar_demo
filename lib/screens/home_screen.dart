import 'package:calendar_plugin/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/color_constants.dart';
import '../models/tasks_data_model.dart';
import '../src/calendar.dart';
import '../src/tab_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  DateTime? currentDates;
  List<bool>? isSelected;
  TabController? tabController;
  int? currentTabSelectedIndex;
  DateTime? selectedDay;
  TextEditingController? weekController;
  TextEditingController? monthController;
  List<TasksDataModel>? tasksDatas;

  initialSetUp() {
    weekController = TextEditingController();
    monthController = TextEditingController();
    tasksDatas = [];
    isSelected = [true, false];
    selectedDay = DateTime.now();
    tasksDatas = tasksData
        .where((element) => element.date == selectedDay!.day.toString())
        .toList();
    weekController!.text = selectedDay!.day.toString();
    monthController!.text = selectedDay!.day.toString();
    currentTabSelectedIndex = 0;
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      if (tabController!.indexIsChanging) {
        setState(() {
          weekController!.text = selectedDay!.day.toString();
          monthController!.text = selectedDay!.day.toString();
        });
      }
      getActiveTabIndex();
    });

    currentDates = DateTime.now();
  }

  @override
  void initState() {
    super.initState();
    initialSetUp();
  }

  void getActiveTabIndex() {
    currentTabSelectedIndex = tabController!.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.lightBlackColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConstants.lightBlackColor,
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 16,
        ),
        title: const Text(
          AppConstants.overAllTasks,
          style: TextStyle(
              fontFamily: AppConstants.interString,
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Colors.white),
        ),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
              hasScrollBody: true,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        buildTabBar(),
                      ],
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget buildTabBar() {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(5, 2.6, 3, 5),
                height: 38,
                decoration: BoxDecoration(
                  color: ColorConstants.greyColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TabBar(
                  controller: tabController,
                  onTap: (index) {
                    setState(() {
                      currentTabSelectedIndex = index;
                      weekController!.text = selectedDay!.day.toString();
                      monthController!.text = selectedDay!.day.toString();
                      tasksDatas = tasksData
                          .where((element) =>
                              element.date == selectedDay!.day.toString())
                          .toList();
                    });
                  },
                  indicator: (currentTabSelectedIndex == 0)
                      ? const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4)))
                      : (currentTabSelectedIndex == 1)
                          ? const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4)))
                          : const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4))),
                  labelColor: ColorConstants.amberColors,
                  unselectedLabelColor: ColorConstants.darkGreyColor,
                  labelStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.amberColors),
                  labelPadding: EdgeInsets.zero,
                  indicatorWeight: 0,
                  tabs: [
                    TabWidget(
                        label: AppConstants.weekString, rightDivider: false),
                    TabWidget(
                        label: AppConstants.monthString, rightDivider: false),
                  ],
                  
                ),
              ),
            ),
            buildTabBarViewStuff()
          ],
        ));
  }

  Widget buildTabBarViewStuff() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: TabBarView(controller: tabController, children: [
        SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 80,
                child: AnimatedHorizontalCalendar(
                  isInWeek: true,
                  date: DateTime.now(),
                  selectedColor: ColorConstants.amberColors,
                  textColor: Colors.white,
                  tableCalenderThemeData: ThemeData.light().copyWith(
                    primaryColor: ColorConstants.greenColor,
                    colorScheme:
                        ColorScheme.light(primary: ColorConstants.greenColor),
                    buttonTheme: const ButtonThemeData(
                        textTheme: ButtonTextTheme.primary),
                  ),
                  onDateSelected: (date) async {
                    setState(() {
                      weekController!.text = date;
                      tasksDatas = tasksData
                          .where((element) => element.date == date)
                          .toList();
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FractionallySizedBox(
                  widthFactor: 0.85,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${DateFormat.MMM().format(DateTime.now())} ",
                            style: const TextStyle(
                                fontFamily: AppConstants.interString,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 22,
                            child: TextField(
                              controller: weekController,
                              style: const TextStyle(
                                  fontFamily: AppConstants.interString,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.white),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontFamily: AppConstants.interString,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                              readOnly: true,
                            ),
                          ),
                          const Text(
                            ",",
                            style: TextStyle(
                                fontFamily: AppConstants.interString,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          Text(
                            selectedDay!.year.toString(),
                            style: const TextStyle(
                                fontFamily: AppConstants.interString,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white),
                          )
                        ],
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Row(
                              children: [
                                Text(
                                  "${tasksDatas!.length.toString()} ",
                                  style: const TextStyle(
                                      fontFamily: AppConstants.interString,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                                tasksDatas!.length > 1
                                    ? const Text(
                                        AppConstants.tasksString,
                                        style: TextStyle(
                                            fontFamily:
                                                AppConstants.interString,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Colors.white),
                                      )
                                    : const Text(
                                        AppConstants.taskString,
                                        style: TextStyle(
                                            fontFamily:
                                                AppConstants.interString,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                              ],
                            ),
                          )),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: tasksDatas!.length,
                          itemBuilder: (context, index) {
                            TasksDataModel tasksDataModel = tasksDatas![index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              shadowColor: Colors.grey,
                              elevation: 15,
                              child: ClipPath(
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorConstants.amberColors,
                                              width: 15)),
                                      color: ColorConstants.blackColorss,
                                    ),
                                    padding: const EdgeInsets.all(20.0),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tasksDataModel.title ?? "",
                                          style: TextStyle(
                                              fontFamily:
                                                  AppConstants.interString,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color:
                                                  ColorConstants.amberColors),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 3.0, bottom: 3),
                                          child: Text(
                                            tasksDataModel.description ?? "",
                                            style: const TextStyle(
                                                fontFamily:
                                                    AppConstants.interString,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.alarm,
                                              color: Colors.white,
                                              size: 17,
                                            ),
                                            const Text(" "),
                                            Text(
                                              tasksDataModel.time ?? "",
                                              style: TextStyle(
                                                  fontFamily:
                                                      AppConstants.interString,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: ColorConstants
                                                      .purpleColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 80,
                child: AnimatedHorizontalCalendar(
                  isInWeek: false,
                  date: DateTime(currentDates!.year, currentDates!.month, 01),
                  selectedColor: ColorConstants.amberColors,
                  textColor: Colors.white,
                  tableCalenderThemeData: ThemeData.light().copyWith(
                    primaryColor: ColorConstants.greenColor,
                    colorScheme:
                        ColorScheme.light(primary: ColorConstants.greenColor),
                    buttonTheme: const ButtonThemeData(
                        textTheme: ButtonTextTheme.primary),
                  ),
                  onDateSelected: (date) async {
                    setState(() {
                      monthController!.text = date;
                      tasksDatas = tasksData
                          .where((element) => element.date == date)
                          .toList();
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FractionallySizedBox(
                  widthFactor: 0.85,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${DateFormat.MMM().format(DateTime.now())} ",
                            style: const TextStyle(
                                fontFamily: AppConstants.interString,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 22,
                            child: TextField(
                              controller: monthController,
                              style: const TextStyle(
                                  fontFamily: AppConstants.interString,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.white),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontFamily: AppConstants.interString,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                              readOnly: true,
                            ),
                          ),
                          const Text(
                            ",",
                            style: TextStyle(
                                fontFamily: AppConstants.interString,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          Text(
                            selectedDay!.year.toString(),
                            style: const TextStyle(
                                fontFamily: AppConstants.interString,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white),
                          )
                        ],
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Row(
                              children: [
                                Text(
                                  "${tasksDatas!.length.toString()} ",
                                  style: const TextStyle(
                                      fontFamily: AppConstants.interString,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                                tasksDatas!.length > 1
                                    ? const Text(
                                        AppConstants.tasksString,
                                        style: TextStyle(
                                            fontFamily:
                                                AppConstants.interString,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Colors.white),
                                      )
                                    : const Text(
                                        AppConstants.taskString,
                                        style: TextStyle(
                                            fontFamily:
                                                AppConstants.interString,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                              ],
                            ),
                          )),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: tasksDatas!.length,
                          itemBuilder: (context, index) {
                            TasksDataModel tasksDataModel = tasksDatas![index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              shadowColor: Colors.grey,
                              elevation: 15,
                              child: ClipPath(
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorConstants.amberColors,
                                              width: 15)),
                                      color: ColorConstants.blackColorss,
                                    ),
                                    padding: const EdgeInsets.all(20.0),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tasksDataModel.title ?? "",
                                          style: TextStyle(
                                              fontFamily:
                                                  AppConstants.interString,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color:
                                                  ColorConstants.amberColors),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 3.0, bottom: 3),
                                          child: Text(
                                            tasksDataModel.description ?? "",
                                            style: const TextStyle(
                                                fontFamily:
                                                    AppConstants.interString,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 3.0),
                                              child: Icon(
                                                Icons.alarm,
                                                color: Colors.white,
                                                size: 17,
                                              ),
                                            ),
                                            const Text(" "),
                                            Text(
                                              tasksDataModel.time ?? "",
                                              style: TextStyle(
                                                  fontFamily:
                                                      AppConstants.interString,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: ColorConstants
                                                      .purpleColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
