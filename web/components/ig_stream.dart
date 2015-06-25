library igtream;

import "dart:html" as html;
import "dart:async";
import "dart:convert" as convert;
import "dart:js" as js;
import "package:angular2/angular2.dart";


@Component(
  selector: "ig-hyperlapse-stream",
  events: const ["onplay"],
  lifecycle: const [onAllChangesDone]
)
@View(
template:
"""
<video height="100%" width="100%" autoplay muted>
  <source src="" type="video/mp4">
  <p>Not supported video tag</p>
</video>
"""
)
class IGStream {
  List<Map> videos = [];
  html.VideoElement videoEl;
  num videoIndex = 0;
  String nextUrl;

  EventEmitter onplay = new EventEmitter();

  IGStream(ElementRef ref) {

    var el = ref.nativeElement as html.HtmlElement;

    videoEl = el.children.first;
    videoEl.addEventListener("ended", (_) => playNextVideo());

    fetchVideos();
  }

  fetchVideosCallback(response) {
    Map result = convert.JSON.decode(
        js.context['JSON'].callMethod(
            'stringify',
            [response]
        )
    );
    List<Map> returnedObjects = result['data'];

    for (var i = 0; i < returnedObjects.length; i++) {
      if (returnedObjects[i]['type'] == "video") {
        videos.add(returnedObjects[i]);
      }
    }
    if(videoIndex == 0) {
      initializeContent();
    }
    nextUrl = result['pagination']['next_url'];
  }

  fetchVideos() {
    var url = nextUrl != null ? nextUrl : "https://api.instagram.com/v1/tags/hyperlapse/media/recent?client_id=425a6039c8274956bc10387bba3597e8";

    jsonp(url+"&count=4").then((result){
      List<Map> returnedObjects = result['data'];

      for (var i = 0; i < returnedObjects.length; i++) {
        if (returnedObjects[i]['type'] == "video") {
          videos.add(returnedObjects[i]);
        }
      }
      if(videoIndex == 0) {
        initializeContent();
      }
      nextUrl = result['pagination']['next_url'];
    });
  }

  initializeContent() {
    playVideo(0);
  }

  playVideo(num index) {
    var videoObj =  videos[index];
    videoEl.src = videoObj['videos']['standard_resolution']['url'];
    videoEl.load();

    // send play event
    onplay.add(videoObj);
  }

  playNextVideo(){
    if(videoIndex == videos.length - 1) return;
    videoIndex++;
    playVideo(videoIndex);

    // fetch more videos if we are near the end
    if(videoIndex == videos.length - 2) {
      this.fetchVideos();
    }
  }

  onAllChangesDone() {

  }
}

Future<Map> jsonp(String url, [String callbackParam = "callback"]) {
  var completer = new Completer<Map>();

  var processData = (result) {
    Map map = convert.JSON.decode(
        js.context['JSON'].callMethod(
            'stringify',
            [result]
        )
    );
    completer.complete(map);
  };
  js.context[callbackParam] = processData;

  html.ScriptElement script = new html.ScriptElement();
  script.src = url+"&callback=$callbackParam";
  html.document.body.children.add(script);
  script.remove();

  return completer.future;
}