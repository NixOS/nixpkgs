import 'package:sqlite3/sqlite3.dart';

void main() {
  final database = sqlite3.openInMemory();
  try {
    final result = database.select('SELECT 40 + 2 AS answer');
    print(result.single['answer']);
  } finally {
    database.dispose();
  }
}
