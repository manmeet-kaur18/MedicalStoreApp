// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';

// class ApiService  {
//   static Future<List<dynamic>>  _get(String url)async{
//     try{final response = await http.get(url);
//     if(response.statusCode==200){
//       return json.decode(response.body);
//     }
//     else{
//       return null;
//     }}
//     catch(ex){
//       return null;
//     }
//   }

// }
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ApiService  {
  static Future<List<dynamic>>  _get(String url)async{
    try{final response = await http.get(url);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return null;
    }}
    catch(ex){
      return null;
    }
  }
    static Future<List<dynamic>> doctorlist()async{
    return await _get('http://192.168.1.5:8080/medicalstoredetails');
  }
  static Future<List<dynamic>> getmedicinelist()async{
    return await _get('http://192.168.1.5:8080/medicinessearch');
  }
  static Future<bool> decreseStock(Map<String,dynamic> decreasecount) async{
    try{
    final response=await http.post('http://192.168.1.5:8080/decreasestock',body:decreasecount );
    return response.statusCode ==201;
    }catch(e){
      return false;
    }
  }
  static Future<bool> increaseStock(Map<String,dynamic> increasecount) async{
    try{
    final response=await http.post('http://192.168.1.5:8080/decreasestock',body:increasecount );
    return response.statusCode ==201;
    }catch(e){
      return false;
    }
  }
 
}
