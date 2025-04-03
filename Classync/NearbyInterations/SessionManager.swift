//
//  SessionManager.swift
//  classync
//
//  Created by Adriel Dube on 3/15/25.
//

import Foundation
import NearbyInteraction
import MultipeerConnectivity



class SessionManager:  NSObject, NISessionDelegate, ObservableObject{
    @Published var connectedPeer: MCPeerID?
    
    var discoveredDevices: [MCPeerID] {
        return sharedDiscovery.discoveredDevices
    }
    private let sharedDiscovery: SharedPeerDiscovery
    var session: NISession?
    var peerDiscoveryToken: NIDiscoveryToken?
    var mpc: MPCSession?
    var sharedToken = false
    var peerDisplayName: String?
    var targetDistance = 0.3
    @Published var status  = ""
    @Published var distance = ""
    @Published var currDistance = 0.0
    @Published var direction: simd_float3? = nil
    @Published var connected = false
    @Published var findPeer = false
    @Published var confirmedAttendance = false

    
    init(sharedDiscovery: SharedPeerDiscovery) {
        self.sharedDiscovery = sharedDiscovery
        super.init()
            
            // ADD THIS:
            sharedDiscovery.onDevicesChanged = { [weak self] _ in
                DispatchQueue.main.async {
                    self?.objectWillChange.send()
                }
            }
    }
      
  
    
    func startup(){
        session = NISession()
        session?.delegate = self
        
        sharedToken = false
        connectedPeer = nil
        
        mpc = nil
        findPeer = true
   
        startupMPC()
        status = "Discovering Peers..."
        
    }
    
    func reset(){
        session!.invalidate()
        direction = nil
        distance = ""
        mpc = nil
        sharedDiscovery.reset()
    }
    
    func endSession(){
        reset()
        peerDiscoveryToken = nil
        connectedPeer = nil
        connected = false
        findPeer = false
 
    }
    
    func startupMPC() {
        if mpc == nil {
            mpc = MPCSession(service: "nisample", identity: "com.example.apple-samplecode.simulator.peekaboo-nearbyinteraction", maxPeers: 1, sharedDiscovery: sharedDiscovery)
     
            mpc?.peerConnectedHandler = connectedToPeer
            mpc?.peerDataHandler = dataReceivedHandler
            mpc?.peerDisconnectedHandler = disconnectedFromPeer
        }
        mpc?.invalidate()
        mpc?.start()
    }

    func connect(peerID:MCPeerID){
        mpc?.connect(peerID: peerID)
    }
    
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        guard let peerToken = peerDiscoveryToken else {
            status = "Don't have peer token"
            return
        }
        // Find the right peer.
        let peerObj = nearbyObjects.first { (obj) -> Bool in
            return obj.discoveryToken == peerToken
        }
        DispatchQueue.main.async {
                // Update distance
            self.currDistance = Double(peerObj?.distance ?? 0.0)

            self.distance = String(format: "%.2f", self.currDistance)

            // Update direction
            self.direction = peerObj?.direction
            
            if self.currDistance <= self.targetDistance{
                self.status = "Successfully registered for attendance"
                self.confirmedAttendance = true
                
                }
            }
    }
    
    func connectedToPeer(peer: MCPeerID) {
        guard let myToken = session?.discoveryToken else {
            status = "Interaction interrupted"
            reset()
            return
        }
        
        if let existingPeer = connectedPeer, existingPeer != peer {
                mpc?.invalidate() // Disconnect the existing peer
            }
        
        if !sharedToken{
            shareToken(token: myToken)
        }
    
        connectedPeer = peer
        status = "Connected"
        peerDisplayName = peer.displayName
        self.connected = true

    }
    
    func disconnectedFromPeer(peer: MCPeerID) {
        if connectedPeer == peer {
            connectedPeer = nil
            sharedToken = false
            reset()
        }
    }
    
    func dataReceivedHandler(data: Data, peer: MCPeerID) {
        guard let discoveryToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else {
            status = "Failed to decode discovery token."
            return
        }
        peerDidShareDiscoveryToken(peer: peer, token: discoveryToken)
    }

    func shareToken(token: NIDiscoveryToken) {
        guard let encodedData = try?  NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
            fatalError("Unexpectedly failed to encode discovery token.")
        }
        mpc?.sendDataToAllPeers(data: encodedData)
        sharedToken = true
    }
    
    func peerDidShareDiscoveryToken(peer: MCPeerID, token: NIDiscoveryToken) {
        if connectedPeer != peer {
            status = "Received token from unexpected peer."
            return
        }
        // Create a configuration.
        peerDiscoveryToken = token
        let config = NINearbyPeerConfiguration(peerToken: token)
        session?.run(config)
    }
    
 
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        guard let peerToken = peerDiscoveryToken else {
            status = "Don't have peer token"
            reset()
            return
        }
        // Find the right peer.
        let peerObj = nearbyObjects.first { (obj) -> Bool in
            return obj.discoveryToken == peerToken
        }

        if peerObj == nil {
                connectedPeer = nil
                peerDiscoveryToken = nil
                return
        }
        
        switch reason {
            
        case .peerEnded:
            peerDiscoveryToken = nil
            connectedPeer = nil
            session.invalidate()
            startup()
            status = "Peer Ended"
        case .timeout:
            
            // The peer timed out, but the session is valid.
            // If the configuration is valid, run the session again.
            if let config = session.configuration {
                session.run(config)
            }
            status = "Peer Timeout"
            reset()
        default:
            fatalError("Unknown and unhandled NINearbyObject.RemovalReason")
        }
    }
    

    func sessionSuspensionEnded(_ session: NISession) {
        if let config = self.session?.configuration {
            session.run(config)
        } else {
            startup()
        }

    }
    
    func session(_ session: NISession, didInvalidateWith error: Error) {
            
        // If the app lacks user approval for Nearby Interaction, present
        // an option to go to Settings where the user can update the access.
        if case NIError.userDidNotAllow = error {
            if #available(iOS 15.0, *) {
                // In iOS 15.0, Settings persists Nearby Interaction access.

                // Create an alert that directs the user to Settings.
                let accessAlert = UIAlertController(title: "Access Required",
                                                message: """
                                                NIPeekaboo requires access to Nearby Interactions for this sample app.
                                                Use this string to explain to users which functionality will be enabled if they change
                                                Nearby Interactions access in Settings.
                                                """,
                                                preferredStyle: .alert)
                accessAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                accessAlert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
                    // Send the user to the app's Settings to update Nearby Interactions access.
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }))

                // Updated presentation style to use view controller presentation
                DispatchQueue.main.async {
                                let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                                let topViewController = scene?.windows.first(where: { $0.isKeyWindow })?.rootViewController?.topMostViewController()
                                topViewController?.present(accessAlert, animated: true, completion: nil)
                    }
            } else {
        
            }
            return
        }
        // Recreate a valid session.
        startup()
    }
  
}
extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? self
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? self
        }
        return self
    }
}
