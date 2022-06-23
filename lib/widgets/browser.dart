import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Browser extends StatefulWidget {
  const Browser({Key? key}) : super(key: key);

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  late WebViewController _controller;
  bool isForwardActive = false;
  bool isBackActive = false;
  bool? isLoading = false;
  List<String> history = [];
  List<String> favorits = [];
  bool openHistory = false;
  bool openList = false;
  String currentUrl = '';

  void currentState() async {
    await _controller.canGoBack() ? isBackActive = true : isBackActive = false;
    await _controller.canGoForward() ? isForwardActive = true : isForwardActive = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView Flutter'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                  color: isBackActive ? Colors.black : Colors.grey[400],
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    _controller.goBack();
                  }),
              IconButton(
                color: isForwardActive ? Colors.black : Colors.grey[400],
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => _controller.goForward(),
              ),
              isLoading!
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2.0,
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.replay),
                      onPressed: () => _controller.reload(),
                    ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onSubmitted: (String value) {
                      currentState();
                      setState(() {
                        _controller.loadUrl(value);
                        value = '';
                      });
                    },
                  ),
                ),
              ),
              favorits.contains(currentUrl)
                  ? IconButton(
                      icon: const Icon(Icons.star),
                      onPressed: () {
                        setState(() {
                          favorits.remove(currentUrl);
                        });
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.star_border_outlined),
                      onPressed: () {
                        setState(() {
                          favorits.add(currentUrl);
                        });
                      },
                    ),
              favorits.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        openList
                            ? setState(() {
                                openList = false;
                              })
                            : setState(() {
                                openList = true;
                              });
                      }),
              IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () {
                    openHistory
                        ? setState(() {
                            openHistory = false;
                          })
                        : setState(() {
                            openHistory = true;
                          });
                  }),
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => _controller.loadUrl('https://flutter.dev'),
              ),
            ],
          ),
          openHistory
              ? Column(
                  children: history
                      .map((url) => Text(
                            url,
                            style: const TextStyle(fontSize: 20),
                          ))
                      .toList())
              : const SizedBox(),
          openList
              ? Column(
                  children: favorits
                      .map((url) => Text(
                            url,
                            style: const TextStyle(fontSize: 20),
                          ))
                      .toList())
              : const SizedBox(),
          Expanded(
            child: WebView(
              initialUrl: 'https://flutter.dev',
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (String value) {
                setState(() {
                  isLoading = true;
                });
              },
              onPageFinished: (String value) {
                currentUrl = value;
                history.add(value);
                isLoading = false;
                currentState();
              },
              onWebViewCreated: (contoller) {
                _controller = contoller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
