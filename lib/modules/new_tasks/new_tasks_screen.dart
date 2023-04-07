import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/shared/cubit/states.dart';
import '../../shared/componants/componants.dart';
import '../../shared/cubit/cubit.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return BlocConsumer<AppCubit, AppStates>(
     listener: (context, state) {},
     builder: (context, state){

       var tasks = AppCubit.get(context).newTasks1;


       return tasksBuilder(
           tasks: tasks
       );
    }

   );
  }

}
