import Toybox.WatchUi;
import Toybox.Graphics;

class TalkToAIView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    private var _status = "Ready";

    function setStatus(status) {
        _status = status;
        WatchUi.requestUpdate();
    }

    function onUpdate(dc) {
        System.println("View onUpdate called");
        // Use a high-visibility color for debugging
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        System.println("Screen Size: " + width + "x" + height);

        // Draw Title
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height / 2 - 40, Graphics.FONT_LARGE, "TalkToAI", Graphics.TEXT_JUSTIFY_CENTER);

        // Draw Status
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height / 2 + 10, Graphics.FONT_MEDIUM, _status, Graphics.TEXT_JUSTIFY_CENTER);

        // Draw Footer
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height - 60, Graphics.FONT_XTINY, "Press Select to Ask AI", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
