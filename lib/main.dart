import 'dart:async';
import 'dart:convert'; // Добавьте этот импорт для работы с JSON
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';//Shared Preferences
import 'dart:io';
//import 'package:path_provider/path_provider.dart';//Файловая система
//import 'package:flutter/material.dart';

Future<Map<String, dynamic>> fetchQuote() async {
  final response = await http.get(Uri.parse('https://api.quotable.io/random'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body); // Декодируем JSON-ответ
  } else {
    throw Exception('Failed to load quote');
  }
}

class Quote {
  final String content;
  final String author;

  Quote({required this.content, required this.author});

  @override
  String toString() {
    return '"$content" - $author';
  }
}

//Shared Preferences
Future<void> saveQuoteToPreferences(Quote quote) async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('quote_content', quote.content);
  await prefs.setString('quote_author', quote.author);
}

Future<Quote?> getQuoteFromPreferences() async{
  final prefs = await SharedPreferences.getInstance();
  final content = prefs.getString('quote_content');
  final author = prefs.getString('quote_author');
  if(content != null && author != null){
    return Quote(content: content, author: author);
  }
  return null;
}

//Файловая система
Future<void> saveQuoteToFile(Quote quote) async {
  try {
    final directory = Directory.current.path;
    print('Directory path: $directory');
    final file = File('$directory/quotes.txt');
    await file.writeAsString('${quote.content}\n${quote.author}');
    print('Quote saved to file.');
  } catch (e) {
    print('Error saving quote to file: $e');
  }
}

Future<Quote?> getQuoteFromFile() async {
  try {
    final directory = Directory.current.path;
    print('Directory path: $directory');
    final file = File('$directory/quotes.txt');
    if (await file.exists()) {
      final contents = await file.readAsString();
      final lines = contents.split('\n');
      if (lines.length >= 2) {
        return Quote(content: lines[0], author: lines[1]);
      }
    } else {
      print('File does not exist.');
    }
  } catch (e) {
    print('Error reading file: $e');
  }
  return null;
}


Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();


  var quote = Quote(content: 'Example quote', author: 'Author');
  //пример использования Shared Preferences
  //await saveQuoteToPreferences(quote);
  //var retrievedQuote = await getQuoteFromPreferences();
  //print('Shared Preferences: $retrievedQuote');

  //пример использования файловой системы
try
{
  String text = "Hello METANIT.COM\n";  // текст для записи
  File file = File("hello.txt");
  await file.writeAsString(text);
  print("File has been written");
}catch (e){
  print('Error $e');
}


  //await saveQuoteToFile(quote);
  //var retrievedQuote = await getQuoteFromFile();
  //print('File System: $retrievedQuote');

 // try {
   // Map<String, dynamic> quote = await fetchQuote();
    // Выбираем определенные элементы из JSON-ответа
   // String content = quote['content'];
   // String author = quote['author'];

   // var quote1 = Quote(content: content, author: author);

   // print(quote1);
 // } catch (e) {
 //   print('Error: $e');
//  }
}