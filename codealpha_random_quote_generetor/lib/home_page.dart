import 'package:codealpha_random_quote_generator/quote_model.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool inProgress = false;
  QuoteModel? quote;

  @override
  void initState() {
    _fetchQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: () async {
             await Share.share('${quote!.q} \n Writer: ${quote!.a}',subject: 'Random Quote',sharePositionOrigin: Rect.fromCenter(center: Offset.zero, width: 50, height: 100));

            }, icon: Icon(Icons.share,color: Colors.white,)),
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Quotes",
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'monospace',
                  fontSize: 24,
                ),
              ),
              const Spacer(),
              Text(
                quote?.q ?? "_____________",
                style: const TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                quote?.a ?? ".....",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white54,
                  fontFamily: 'serif',
                ),
              ),
              const Spacer(),
              inProgress
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : ElevatedButton(
                      onPressed: () {
                        _fetchQuote();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      child: const Text(
                        "Generate",
                        style: TextStyle(color: Colors.black87),
                      ),
                    )
            ],
          ),
        ),
      ),
    ));
  }

  _fetchQuote() async {
    setState(() {
      inProgress = true;
    });
    try {
      final fetchedQuote = await Api.fetchRandomQuote();
      debugPrint(fetchedQuote.toJson().toString());
      setState(() {
        quote = fetchedQuote;
      });
    } catch (e) {
      debugPrint("Failed to generate quote");
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
