import Toybox.WatchUi;
import Toybox.BluetoothLowEnergy;
import Toybox.System;

class VoiceAIDelegate extends WatchUi.BehaviorDelegate {
    
    // UUIDs should match the iOS App
    private var serviceUUID = BluetoothLowEnergy.stringToUuid("AD68E776-857D-4F3D-9D2F-9B67DB11A77E");
    private var charUUID = BluetoothLowEnergy.stringToUuid("782079C1-F091-4D9D-A3D8-7241A5C0E28E");

    function initialize() {
        BehaviorDelegate.initialize();
        setupBLE();
    }

    function setupBLE() {
        var profile = {
            :uuid => serviceUUID,
            :characteristics => [{
                :uuid => charUUID,
                // Using integer bitmask for properties: READ(2) | WRITE(8) | NOTIFY(16) = 26
                :properties => 26
            }]
        };
        BluetoothLowEnergy.registerProfile(profile);
    }

    function onSelect() {
        System.println("Notifying iOS App via BLE...");
        // Signal the phone to start recording
        var characteristic = BluetoothLowEnergy.getService(serviceUUID).getCharacteristic(charUUID);
        var data = [83, 84, 65, 82, 84]b; // "START" in bytes
        characteristic.requestWrite(data, { :writeType => BluetoothLowEnergy.WRITE_TYPE_WITH_RESPONSE });
        return true;
    }
}
