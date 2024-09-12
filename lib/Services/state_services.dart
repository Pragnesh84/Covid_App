import 'dart:convert';

import 'package:covid_app/Services/Utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:covid_app/Model/WorldStatesModel.dart';


class StateServices{

  Future<WorldStatesModel> fetchWorldStateApi() async{
     
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));

    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);
    }else{
      throw Exception("Error");
    }

  }

  Future<List<dynamic>> countriceListApi() async{

    final response = await http.get(Uri.parse(AppUrl.countriesList));
    var data;

    if(response.statusCode == 200){
      data = jsonDecode(response.body.toString());
      return data;
    }else{
      throw Exception("Error");
    }

  }
}