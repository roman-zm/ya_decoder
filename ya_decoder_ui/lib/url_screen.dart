import 'dart:core';

import 'package:flutter/material.dart';
import 'package:ya_decoder_ui/get_and_save_gpx.dart';
import 'package:ya_decoder_ui/progress_button.dart';
import 'package:ya_route_decoder/ya_route_decoder.dart';

class UrlInputPage extends StatefulWidget {
  const UrlInputPage({super.key});

  @override
  UrlInputPageState createState() => UrlInputPageState();
}

class UrlInputPageState extends State<UrlInputPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  bool showClearButton = false;
  bool openInBrowser = false;

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        showClearButton = controller.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("URL Input"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Enter URL",
                hintText: "https://example.com",
                suffixIcon: showClearButton
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                        },
                      )
                    : null,
              ),
              validator: (value) {
                if (value == null || value.isEmpty == true) {
                  return "Please enter a URL";
                }
                try {
                  final uri = Uri.parse(value);
                  if (uri.scheme.isEmpty) {
                    return "Enter a valid URL including the scheme (e.g. https://)";
                  }
                } on FormatException catch (_) {
                  return "Enter a valid URL";
                }
                return null;
              },
            ),
            CheckboxListTile(
              title: const Text('Открыть в браузере'),
              value: openInBrowser,
              tristate: false,
              onChanged: (value) {
                setState(() {
                  openInBrowser = value == true;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ProgressButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() == true) {
                    try {
                      await getGpx(controller.text, openInBrowser);
                    } on YaDecoderError catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.message)));
                    }
                  }
                },
                text: "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
