library app.igtream;

import "dart:html" as html;
import "dart:async";
import "dart:convert" as convert;
import "dart:js" as js;
import "package:angular2/angular2.dart";
import "package:angular2/router.dart";
import "package:angular2/src/facade/async.dart" show ObservableWrapper;
import 'package:json_object/json_object.dart';

@Component(
    selector: "ig-hyperlapse-stream",
    events: const ["onplay"],
    lifecycle: const [LifecycleEvent.onAllChangesDone])
@View(template: """
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

  EventEmitter onplay = new EventEmitter();
  Jsonp _jsonp;

  IGStream(ElementRef ref, this._jsonp) {
    var el = ref.nativeElement as html.HtmlElement;

    _videoEl = el.children.first;
    _videoEl.addEventListener("ended", (_) => _playNextVideo());

    _fetchVideos();
  }

  _fetchVideos() {
    var url = _nextUrl != null
        ? _nextUrl
        : "https://api.instagram.com/v1/tags/hyperlapse/media/recent?client_id=425a6039c8274956bc10387bba3597e8";

    _jsonp.request("$url&callback=JSONP_CALLBACK").listen((resp) {
      JsonObject data = resp.json();
      List<Map> returnedObjects = data['data'];

      for (var i = 0; i < returnedObjects.length; i++) {
        if (returnedObjects[i]['type'] == "video") {
          _videos.add(returnedObjects[i]);
        }
      }
      if (_videoIndex == 0) {
        initializeContent();
      }
      _nextUrl = data['pagination']['next_url'];
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

  onAllChangesDone() {
    //nothing
  }
}
