import Toybox.WatchUi;
import Toybox.Graphics;

class TalkToAIView extends WatchUi.View {
    private var _statusLabel;

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        _statusLabel = View.findDrawableById("StatusLabel");
    }

    function setStatus(status) {
        if (_statusLabel != null) {
            _statusLabel.setText(status);
        }
        WatchUi.requestUpdate();
    }

    function onUpdate(dc) {
        // Call the parent onUpdate to draw the layout
        View.onUpdate(dc);
    }
}
