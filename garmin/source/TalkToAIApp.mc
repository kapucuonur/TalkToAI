import Toybox.Application;
import Toybox.WatchUi;

class TalkToAIApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        var view = new TalkToAIView();
        return [ view, new VoiceAIDelegate(view) ];
    }
}
