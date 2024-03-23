import 'dart:convert';
import 'package:codealpha_random_quote_generator/quote_model.dart';
import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl = "https://zenquotes.io/api/random";

  static Future<QuoteModel> fetchRandomQuote() async {


    final response = await http.get( Uri.parse("${baseUrl}", ),headers: {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    } );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return QuoteModel.fromJson(data[0]);
    } else {
      throw Exception("Failed to generate quote");
    }
  }
}
