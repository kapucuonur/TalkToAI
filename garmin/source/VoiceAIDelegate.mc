import Toybox.WatchUi;
import Toybox.Communications;
import Toybox.System;

class VoiceAIDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        System.println("Triggering Voice AI...");
        // You would replace this with your Twilio number
        Communications.makePhoneCall("123456789", null);
        return true;
    }
}
