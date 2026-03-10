import Foundation
import CoreBluetooth

class BLEManager: NSObject, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager!
    var transferCharacteristic: CBMutableCharacteristic?
    
    let serviceUUID = CBUUID(string: "AD68E776-857D-4F3D-9D2F-9B67DB11A77E")
    let characteristicUUID = CBUUID(string: "782079C1-F091-4D9D-A3D8-7241A5C0E28E")
    
    var onCommandReceived: ((String) -> Void)?
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [CBPeripheralManagerOptionRestoreIdentifierKey: "TalkToAIPeripheralRestore"])
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            setupPeripheral()
        }
    }
    
    func setupPeripheral() {
        let characteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: [.write, .read, .notify],
            value: nil,
            permissions: [.writeable, .readable]
        )
        
        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [characteristic]
        
        peripheralManager.add(service)
        transferCharacteristic = characteristic
        
        // Start advertising
        peripheralManager.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
            CBAdvertisementDataLocalNameKey: "TalkToAiPhone"
        ])
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if let data = request.value, let command = String(data: data, encoding: .utf8) {
                print("Received command: \(command)")
                onCommandReceived?(command)
                peripheral.respond(to: request, withResult: .success)
            }
        }
    }
    
    // Handle background restoration
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        // State restoration logic if needed
    }
}
