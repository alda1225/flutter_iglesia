import 'package:flutter/material.dart';
import 'package:flutter_church/src/bloc/login_bloc.dart';
export 'package:flutter_church/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget{
  
  final loginBloc = LoginBloc();
  
  Provider({ Key key, Widget child })
  :super(key:key,child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
  

 

}