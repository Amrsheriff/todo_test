import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:untitled/shared/componants/componants.dart';
import 'package:untitled/shared/cubit/states.dart';
import '../shared/cubit/cubit.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var tittleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  double? selectedTime;
  double to2Double(TimeOfDay myTime) => myTime.hour + myTime.minute/60.0;
  var bottomSheetController;


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDataBaseState)
            {
              Navigator.pop(context);
            }
        },
        builder: (BuildContext context, AppStates state) {

          AppCubit cubit = AppCubit.get(context);
          var tasks = cubit.newTasks;

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              //backgroundColor: Color(0xFF0B222D),
                backgroundColor: Colors.green,
              title: Text(
                  cubit.title[cubit.currentIndex]
              ),
            ),

            body: ConditionalBuilder(
              condition: state is! AppGetDataBaseLoadingState,
              builder: (context)=> cubit.screens[cubit.currentIndex],
              fallback: (context)=> Center(child: CircularProgressIndicator()),
            ),


            floatingActionButton: ConditionalBuilder(
              condition: cubit.currentIndex == 0,
              builder: (context) => FloatingActionButton(
                  //backgroundColor: Color(0xFF266171),
                  backgroundColor: Colors.green,
                  onPressed: () {
                    if (cubit.isBottomSheetShown) {
                      if (formKey.currentState!.validate()) {
                        cubit.insertToDatabase(
                          title: tittleController.text,
                          time: timeController.text,
                          date: dateController.text,
                        );
                        tittleController.clear();
                        timeController.clear();
                        dateController.clear();
                      }
                    } else {
                      scaffoldKey.currentState
                          ?.showBottomSheet(
                            (context) => Container(
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                    controller: tittleController,
                                    type: TextInputType.text,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return ('title must not be empty');
                                      }
                                    },
                                    label: 'Task title',
                                    prefix: Icons.title),
                                SizedBox(
                                  height: 15.0,
                                ),
                                defaultFormField(
                                  interactiveSelection: false,
                                  controller: timeController,
                                  type: TextInputType.none,
                                  onTap: () {
                                    showTimePicker(
                                      builder: (context, child) => Theme(
                                        data: ThemeData(
                                            colorScheme: ColorScheme.light(
                                              primary: Colors.green,
                                            )
                                        ), child: child!,
                                      ),
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    )
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                      selectedTime = to2Double(value);
                                    });
                                  },
                                  validate: (String value) {
                                    //value = timeController as double;
                                    double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute/60.0;
                                    if (value.isEmpty) {
                                      return ('time must not be empty');
                                    }
                                    else if (selectedTime! < toDouble(TimeOfDay.now())){
                                      return ('wrong time');
                                    }
                                  },
                                  label: 'Task Time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                defaultFormField(
                                  interactiveSelection: false,
                                  controller: dateController,
                                  type: TextInputType.none,
                                  onTap: () {
                                    showDatePicker(
                                        builder: (context, child) => Theme(
                                          data: ThemeData(
                                              colorScheme: ColorScheme.light(
                                                primary: Colors.green,
                                                onPrimary: Colors.white,
                                                surface: Colors.green,
                                              )
                                          ), child: child!,
                                        ),
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2023-12-30'))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return ('date must not be empty');
                                    }
                                  },
                                  label: 'Task Date',
                                  prefix: Icons.calendar_month_sharp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 30.0,
                      )
                          .closed
                          .then((value) {
                        cubit.ChangeBottomSheetState(
                          isShow: false,
                          icon: Icons.edit,
                        );
                      });
                      cubit.ChangeBottomSheetState(
                        isShow: true,
                        icon: Icons.add,
                      );
                    }
                  },
                  child: Icon(
                    cubit.fabIcon,
                  ),

                ),
              fallback: (context) => Visibility(
                visible: false,
                  child: FloatingActionButton(onPressed: (){
                    Navigator.pop(context);
                  }),
              ),
            ),

            bottomNavigationBar: BottomNavigationBar(
              fixedColor: Colors.green,
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu,
                      //color: Colors.blue,
                    ),
                    label: 'Tasks',
                    //backgroundColor: Colors.deepOrange,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline,
                    //color: Colors.green
                    ),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined,
                    //color: Colors.deepOrange,
                    ),
                    label: 'Archived',
                  ),
                ]),
          );
        },
      ),
    );
  }
}
