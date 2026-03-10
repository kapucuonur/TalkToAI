import Toybox.Application;
import Toybox.WatchUi;

class TalkToAIApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        return [ new TalkToAIView(), new VoiceAIDelegate() ];
    }
}
