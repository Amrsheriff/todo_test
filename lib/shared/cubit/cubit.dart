
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/shared/cubit/states.dart';
import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List<Map> newTasks1 = [];
  List<Map> doneTasks1 = [];
  List<Map> archivedTasks1 = [];

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> title = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;

  Future<String> getName() async {
    return 'ALOHA';
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when creating the table ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');
        getDataFromDatabase(database);

      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) {
      txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("${title}", "${date}", "${time}", "new")')
          .then((value) {
        print('$value successfully');
        emit(AppInsertDataBaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when inserting the new table ${error.toString()}');
      });
      return getName();
    });
  }

  void getDataFromDatabase(database)  {

    newTasks=[];
    doneTasks=[];
    archivedTasks=[];

    emit(AppGetDataBaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {

     value.forEach((element){
     if(element['status']== 'new')
       newTasks.add(element);
     else if(element['status']== 'done')
       doneTasks.add(element);
     else archivedTasks.add(element);
     });

     newTasks1 = newTasks;
     doneTasks1 = doneTasks;
     archivedTasks1 = archivedTasks;


     emit(AppGetDataBaseState());
  });

  }

  void updateData({
    required String status,
    required int id,
}) async
  {
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]
     ).then((value) {
       getDataFromDatabase(database);
       emit(AppUpdateDataBaseState());
     });
  }

  void EditData({
    required String title,
    required String time,
    required String date,
    required int id,
  }) async
  {
    //'UPDATE tasks SET title = ?, time = ?, date = ? WHERE id = ?',
    //['$title', id, '$date', '$time']
    database.rawUpdate(
        'UPDATE tasks SET title = ?, time = ?, date = ? WHERE id = ?',
        ['$title', '$time','$date', id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppEditDataBaseState());
    });
  }


  void deleteData({
    required int id,
  }) async
  {
    database.rawUpdate(
        'DELETE FROM tasks WHERE id = ?',
        [id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataBaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void ChangeBottomSheetState({
    required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }

}