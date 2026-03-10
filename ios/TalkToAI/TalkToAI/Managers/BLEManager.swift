import Foundation
import CoreBluetooth

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var garminPeripheral: CBPeripheral?
    
    // Replace with your specific Garmin Service and Characteristic UUIDs
    let serviceUUID = CBUUID(string: "AD68E776-857D-4F3D-9D2F-9B67DB11A77E")
    let characteristicUUID = CBUUID(string: "782079C1-F091-4D9D-A3D8-7241A5C0E28E")
    
    var onCommandReceived: ((String) -> Void)?
    
    override init() {
        super.init()
        // State preservation and restoration is key for background operation
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: "TalkToAIBLERestore"])
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [serviceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        garminPeripheral = peripheral
        garminPeripheral?.delegate = self
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([serviceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == characteristicUUID {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value, let command = String(data: data, encoding: .utf8) {
            onCommandReceived?(command)
        }
    }
    
    // Restore state if app was killed and watch sends a notification
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        if let peripherals = dict[CBCentralManagerRestoredPeripheralsKey] as? [CBPeripheral] {
            garminPeripheral = peripherals.first
            garminPeripheral?.delegate = self
        }
    }
}
