import 'dart:async';
import 'dart:convert'; // Добавьте этот импорт для работы с JSON
import 'package:http/http.dart' as http;

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