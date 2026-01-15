import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class DomainFetcherService {
  static const String telegramUrl = 'https://t.me/s/Streaming_community_sito';

  /// Fetches the HTML from the public Telegram channel and extracts the latest URL.
  Future<String> fetchActiveDomain() async {
    try {
      final response = await http
          .get(Uri.parse(telegramUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to load Telegram channel');
      }

      final document = parser.parse(response.body);

      // Find all message text elements
      final List<Element> messages = document.querySelectorAll(
        '.tgme_widget_message_text',
      );

      // Iterate in reverse order (newest to oldest)
      for (final message in messages.reversed) {
        final String text = message.text;

        if (text.contains('Nuovo:')) {
          // Extraction: Split by "Nuovo:" and take the second part
          final String extracted = text.split('Nuovo:').last;

          // Sanitization: Trim whitespace and remove newlines/extra text
          String sanitized = extracted
              .trim()
              .split('\n')
              .first
              .trim()
              .split(' ')
              .first
              .trim();

          if (sanitized.isNotEmpty) {
            // Validation: Ensure it has a protocol
            if (!sanitized.startsWith('http://') &&
                !sanitized.startsWith('https://')) {
              sanitized = 'https://$sanitized';
            }

            // Basic validation to check if it looks like a domain/URL
            final uri = Uri.tryParse(sanitized);
            if (uri != null && uri.host.isNotEmpty) {
              return sanitized;
            }
          }
        }
      }

      throw Exception('No active domain found in recent messages');
    } catch (e) {
      rethrow;
    }
  }
}
