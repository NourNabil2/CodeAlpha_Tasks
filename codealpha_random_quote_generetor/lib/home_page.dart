
import 'dart:developer';

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
            title:  const Text(
              "Random Quotes",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'monospace',
                fontSize: 24,
              ),
            ),
            leading: IconButton(onPressed: () async {
             await Share.share('${quote!.q} \n Writer: ${quote!.a}',subject: 'Random Quote',sharePositionOrigin: Rect.fromCenter(center: Offset.zero, width: 50, height: 100));

            }, icon: Icon(Icons.share,color: Colors.black,)),
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  color: Colors.grey,
                  fontFamily: 'serif',
                ),
              ),
              const Spacer(),
              inProgress
                  ? const CircularProgressIndicator(
                      color: Colors.black,
                    )
                  : ElevatedButton(
                      onPressed: () {
                        _fetchQuote();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text(
                        "Generate",
                        style: TextStyle(color: Colors.white),
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

      setState(() {
        quote = fetchedQuote;
      });
    } catch (e) {
   log(e.toString());
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
