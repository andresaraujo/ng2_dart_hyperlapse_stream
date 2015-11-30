library app.igtream;

import "dart:html" as html;
import "dart:async" show Completer, Future;
import "dart:convert" as convert;
import "dart:js" as js;
import "package:angular2/angular2.dart";

@Component(
    selector: "ig-hyperlapse-stream",
    template: """
<video height="100%" width="100%" autoplay muted>
  <source src="" type="video/mp4">
  <p>Not supported video tag</p>
</video>
""")
class IGStream {
  List<Map> _videos = [];
  html.VideoElement _videoEl;
  num _videoIndex = 0;
  String _nextUrl;

  @Output() EventEmitter onplay = new EventEmitter();

  IGStream(ElementRef ref) {
    var el = ref.nativeElement as html.HtmlElement;

    _videoEl = el.children.first;
    _videoEl.addEventListener("ended", (_) => _playNextVideo());

    _fetchVideos();
  }

  _fetchVideos() {
    var url = _nextUrl != null
        ? _nextUrl
        : "https://api.instagram.com/v1/tags/hyperlapse/media/recent?client_id=425a6039c8274956bc10387bba3597e8";

    jsonp(url + "&count=4").then((result) {
      List<Map> returnedObjects = result['data'];

      for (var i = 0; i < returnedObjects.length; i++) {
        if (returnedObjects[i]['type'] == "video") {
          _videos.add(returnedObjects[i]);
        }
      }
      if (_videoIndex == 0) {
        initializeContent();
      }
      _nextUrl = result['pagination']['next_url'];
    });
  }

  initializeContent() {
    playVideo(0);
  }

  playVideo(num index) {
    var videoObj = _videos[index];
    _videoEl.src = videoObj['videos']['standard_resolution']['url'];
    _videoEl.load();

    // send play event
    onplay.add(videoObj);
  }

  _playNextVideo() {
    if (_videoIndex == _videos.length - 1) return;
    _videoIndex++;
    playVideo(_videoIndex);

    // fetch more videos if we are near the end
    if (_videoIndex == _videos.length - 2) {
      _fetchVideos();
    }
  }
}

Future<Map> jsonp(String url, [String callbackParam = "callback"]) {
  var completer = new Completer<Map>();

  var processData = (result) {
    Map map = convert.JSON
        .decode(js.context['JSON'].callMethod('stringify', [result]));
    completer.complete(map);
  };
  js.context[callbackParam] = processData;

  html.ScriptElement script = new html.ScriptElement();
  script.src = url + "&callback=$callbackParam";
  html.document.body.children.add(script);
  script.remove();

  return completer.future;
}

const list = const [
  const {/*...*/},
  const {/*...*/}
];
