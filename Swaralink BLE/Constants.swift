//
//  Constants.swift
//  Swaralink BLE
//
//  Created by Dushyant Varshney on 03/01/22.
//

import UIKit

class SWLConstants: NSObject {
    
    let disc_conn_desc = "This function is used to establish a Bluetooth connection with a peripheral device that is running the SwaraLink Peripheral middleware library. If the device has never been connected to this phone before, it must first be put into pairing mode. You can choose to connect to a specific device that has been previously connected, or to connect to the first discovered device. This function can only be called while in the SWLCentralStateIdle state."

    let cancel_disc_conn_desc = "This function is used to cancel a ‘discoverAndConnect’ or ‘directConnect’ process that is currently underway and return to the SWLCentralStateIdle state.\nThis function can only be called while in the SWLCentralStateDiscoveryInProgress state, the SWLCentralStateDiscovered state, or the SWLCentralStateEstablishingConnection state."
 
    let send_data_desc = "This function is used to send data to a connected peripheral device. All data communications are encrypted by default. The data can be any length between 1 byte and 8192 bytes (this is the max length supported by the peripheral). The Major ID Header and Minor ID headers can be any value (one byte each) that you like, and can be useful for your application to specify what the data represents. If you select to send data using an acknowledged transfer, the peripheral device will confirm that the data has been received and you will receive a evtC2PDataAcknowledged event upon completion of the transfer. This function can only be called while in the SWLCentralStateConnected state."

    let clear_kdl_desc = "This function is used to clear the Known Device List (KDL). When a peripheral device has been removed from the KDL, it must be put into pairing mode to establish a new connection."

    let remove_kdl_desc = "This function is used to remove a specific device from the Known Device List (KDL). When a peripheral device has been removed from the KDL, it must be put into pairing mode to establish a new connection."


    let terminate_conn_desc = "This function is used to terminate a current Bluetooth connection. This function can only be called while in the SWLCentralStateConnected state."
    
    let update_peripheral_firmware_desc = "This function is used to perform an over-the-air firmware update on a connected peripheral device. This function can only be called while in the SWLCentralStateConnected state."

    let known_device_list = "This function is used to view the current contents of the Known Device List (KDL). After a peripheral device has connected and paired, it will be added to the KDL."
    
    let directConnect = "This function is used to directly establish a Bluetooth connection with a peripheral device that has been previously paired and is on the Known Device List (KDL).\nIf the device has never been connected to this phone before, you must first use the ‘discoverAndConnect’ API to form an initial connection and pair.\nThis function can only be called while in the SWLCentralStateIdle state."
    
    let diagnosticLog = "This function is used to request diagnostic logs from the peer device.This function can only be called while in the SWLCentralStateConnected state."
    
    let setPeripheralPrioritesDesc = "This function will configure a connected peripheral device to prioritize its operation to optimize for power consumption, data throughput, or range / distance.It is possible to assign the same priority multiple times for maximum optimization. For example: to get the highest possible throughput, set all three priorities to “Increase Throughput”.Note that prioritization involves tradeoffs that impact the user experience. For example, if you heavily prioritize reducing power, there may be a noticeable impact to throughput and responsiveness. If you heavily prioritize increased throughput, the power consumption of the peripheral device will go up. This function can only be called while in the SWLCentralStateConnected state."
    
    let getPeripheralPrioritesDesc = "This function is used to displayed the current Peripheral Priorities."
    
    let configurationParameters = "This function is used to set configuration parameters for the SWLCentral library. Configuration profile files are provided by SwaraLink Technologies. If you do not have a configuration profile file, please contact SwaraLink Technologies’ support team."
}
