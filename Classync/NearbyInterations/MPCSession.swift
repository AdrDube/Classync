//
//  classync_StudentApp.swift
//  classync-Student
//
//  Created by Adriel Dube on 3/30/25.
//


import Foundation
import MultipeerConnectivity



class SharedPeerDiscovery{
    // The shared array of discovered peers
    var onDevicesChanged: (([MCPeerID]) -> Void)?
       
       // Make this @Published if this class will be directly observed
       private(set) var discoveredDevices: [MCPeerID] = [] {
           didSet {
               onDevicesChanged?(discoveredDevices)
           }
       }
    
    // Optional: Add methods to manage the array if needed
    func addPeer(_ peer: MCPeerID) {
        if !discoveredDevices.contains(peer) {
            discoveredDevices.append(peer)
        }
    }
    func reset (){
        discoveredDevices = []
    }
    func removePeer(_ peer: MCPeerID) {
        if let index = discoveredDevices.firstIndex(of: peer) {
            discoveredDevices.remove(at: index)
        }
    }
}

struct MPCSessionConstants {
    static let KeyIdentity: String = "identity"
}

class MPCSession: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    var peerDataHandler: ((Data, MCPeerID) -> Void)?
    var peerConnectedHandler: ((MCPeerID) -> Void)?
    var peerDisconnectedHandler: ((MCPeerID) -> Void)?
    private let sharedDiscovery: SharedPeerDiscovery
    private let serviceString: String
    private let mcSession: MCSession
    private let localPeerID = MCPeerID(displayName: UIDevice.current.name)
    private let identityString: String
    private let maxNumPeers: Int
    private var mcBrowser: MCNearbyServiceBrowser?

    init(service: String, identity: String, maxPeers: Int, sharedDiscovery: SharedPeerDiscovery) {
        serviceString = service
        identityString = identity
        mcSession = MCSession(peer: localPeerID, securityIdentity: nil, encryptionPreference: .required)
        self.sharedDiscovery = sharedDiscovery
        mcBrowser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: serviceString)
        maxNumPeers = maxPeers
        super.init()
        mcSession.delegate = self
        mcBrowser?.delegate = self
    }

    // MARK: - `MPCSession` public methods.
    func start() {

        if mcBrowser == nil {
            mcBrowser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: serviceString)
            mcBrowser?.delegate = self
        }
        mcBrowser?.startBrowsingForPeers()
    }
    
    
    func connect(peerID : MCPeerID ){
        mcBrowser?.invitePeer(peerID, to: mcSession, withContext: nil, timeout: 10)
    }



    func suspend() {
        mcBrowser = nil
    }

    func invalidate() {
        suspend()
        mcSession.disconnect()
    }

    func sendDataToAllPeers(data: Data) {
        sendData(data: data, peers: mcSession.connectedPeers, mode: .reliable)
    }

    func sendData(data: Data, peers: [MCPeerID], mode: MCSessionSendDataMode) {
        do {
            try mcSession.send(data, toPeers: peers, with: mode)
        } catch let error {
            NSLog("Error sending data: \(error)")
        }
    }

    // MARK: - `MPCSession` private methods.
    private func peerConnected(peerID: MCPeerID) {
       
        if let handler = peerConnectedHandler {
            DispatchQueue.main.async {
                handler(peerID)
            }
        }
        if mcSession.connectedPeers.count == maxNumPeers {
            self.suspend()
        }
    }

    private func peerDisconnected(peerID: MCPeerID) {
        if let handler = peerDisconnectedHandler {
            DispatchQueue.main.async {
                handler(peerID)
            }
        }

        if mcSession.connectedPeers.count < maxNumPeers {
            self.start()
        }
    }

    // MARK: - `MCSessionDelegate`.
    internal func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            peerConnected(peerID: peerID)
        case .notConnected:
            peerDisconnected(peerID: peerID)
        case .connecting:
            break
        @unknown default:
            fatalError("Unhandled MCSessionState")
        }
    }

    internal func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let handler = peerDataHandler {
            DispatchQueue.main.async {
                handler(data, peerID)
            }
        }
    }

    internal func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // The sample app intentional omits this implementation.
    }

    internal func session(_ session: MCSession,
                          didStartReceivingResourceWithName resourceName: String,
                          fromPeer peerID: MCPeerID,
                          with progress: Progress) {
        // The sample app intentional omits this implementation.
    }

    internal func session(_ session: MCSession,
                          didFinishReceivingResourceWithName resourceName: String,
                          fromPeer peerID: MCPeerID,
                          at localURL: URL?,
                          withError error: Error?) {
        // The sample app intentional omits this implementation.
    }

    // MARK: - `MCNearbyServiceBrowserDelegate`.
    internal func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        sharedDiscovery.addPeer(peerID)
        }

    internal func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        sharedDiscovery.removePeer(peerID)
    }


    // MARK: - `MCNearbyServiceAdvertiserDelegate`.
    internal func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                             didReceiveInvitationFromPeer peerID: MCPeerID,
                             withContext context: Data?,
                             invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Accept the invitation only if the number of peers is less than the maximum.
        if self.mcSession.connectedPeers.count < maxNumPeers {
            invitationHandler(true, mcSession)
        }
    }
}
