import Toybox.WatchUi;
import Toybox.BluetoothLowEnergy;
import Toybox.System;

class VoiceAIDelegate extends WatchUi.BehaviorDelegate {
    
    // iPhone Peripheral UUIDs
    private var serviceUUID = BluetoothLowEnergy.stringToUuid("AD68E776-857D-4F3D-9D2F-9B67DB11A77E");
    private var charUUID = BluetoothLowEnergy.stringToUuid("782079C1-F091-4D9D-A3D8-7241A5C0E28E");
    private var _device = null;
    private var _view;

    function initialize(view) {
        System.println("Delegate Initializing...");
        BehaviorDelegate.initialize();
        _view = view;
        if (Toybox has :BluetoothLowEnergy) {
            System.println("Registering BLE Delegate...");
            BluetoothLowEnergy.setDelegate(new VoiceAIBleDelegate(self));
        } else {
            System.println("BLE NOT SUPPORTED ON THIS DEVICE");
        }
    }

    function onSelect() {
        System.println("Select Pressed!");
        _view.setStatus("Searching...");
        if (Toybox has :BluetoothLowEnergy) {
            BluetoothLowEnergy.setScanState(BluetoothLowEnergy.SCAN_STATE_SCANNING);
        }
        return true;
    }

    // Called by the BleDelegate when the iPhone is found and connected
    function onDeviceConnected(device) {
        _device = device;
        _view.setStatus("Found iPhone");
        var service = _device.getService(serviceUUID);
        if (service != null) {
            var characteristic = service.getCharacteristic(charUUID);
            if (characteristic != null) {
                System.println("Sending START command...");
                _view.setStatus("Asking AI...");
                characteristic.requestWrite([83, 84, 65, 82, 84]b, { :writeType => BluetoothLowEnergy.WRITE_TYPE_WITH_RESPONSE });
            }
        }
    }
}

class VoiceAIBleDelegate extends BluetoothLowEnergy.BleDelegate {
    private var _parent;
    private var _serviceUUID;

    function initialize(parent) {
        BleDelegate.initialize();
        _parent = parent;
        _serviceUUID = BluetoothLowEnergy.stringToUuid("AD68E776-857D-4F3D-9D2F-9B67DB11A77E");
    }

    function onScanResults(scanResults) {
        for (var result = scanResults.next(); result != null; result = scanResults.next()) {
            if (result instanceof BluetoothLowEnergy.ScanResult) {
                var uuids = result.getServiceUuids();
                for (var uuid = uuids.next(); uuid != null; uuid = uuids.next()) {
                    if (uuid.equals(_serviceUUID)) {
                        System.println("iPhone found! Connecting...");
                        BluetoothLowEnergy.setScanState(BluetoothLowEnergy.SCAN_STATE_OFF);
                        BluetoothLowEnergy.pairDevice(result);
                        break;
                    }
                }
            }
        }
    }

    function onConnectedStateChanged(device, state) {
        if (state == BluetoothLowEnergy.CONNECTION_STATE_CONNECTED) {
            _parent.onDeviceConnected(device);
        }
    }
}
