import 'dart:async';
import 'dart:convert'; // Добавьте этот импорт для работы с JSON
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';//Shared Preferences


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

void main() async {

  //пример использования Shared Preferences
  var quote = Quote(content: 'Example quote', author: 'Author');
  await saveQuoteToPreferences(quote);
  var retrievedQuote = await getQuoteFromPreferences();
  print('Shared Preferences: $retrievedQuote');

  try {
    Map<String, dynamic> quote = await fetchQuote();
    // Выбираем определенные элементы из JSON-ответа
    String content = quote['content'];
    String author = quote['author'];

    var quote1 = Quote(content: content, author: author);

    print(quote1);
  } catch (e) {
    print('Error: $e');
  }
}