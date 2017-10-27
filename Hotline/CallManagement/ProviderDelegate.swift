//
//  ProviderDelegate.swift
//  Hotline
//
//  Created by Steve Baker on 10/27/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import AVFoundation
import CallKit

class ProviderDelegate: NSObject {
    // 1.
    fileprivate let callManager: CallManager
    fileprivate let provider: CXProvider

    init(callManager: CallManager) {
        self.callManager = callManager
        // 2.
        provider = CXProvider(configuration: type(of: self).providerConfiguration)

        super.init()
        // 3.
        provider.setDelegate(self, queue: nil)
    }

    // 4.
    static var providerConfiguration: CXProviderConfiguration {
        let providerConfiguration = CXProviderConfiguration(localizedName: "Hotline")

        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]

        return providerConfiguration
    }

    func reportIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)?) {

        // prepare update to send to system
        let update = CXCallUpdate()
        // add call metadata
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        update.hasVideo = hasVideo

        // use provider to notify system
        provider.reportNewIncomingCall(with: uuid, update: update) { error in

            // now we are inside reportNewIncomingCall's final argument, a completion block

            if error == nil {
                // no error, so add call
                let call = Call(uuid: uuid, handle: handle)
                self.callManager.add(call: call)
            }

            // execute "completion", the final argument that was passed to outer method reportIncomingCall
            // execute if it isn't nil
            completion?(error as NSError?)
        }
    }

}

extension ProviderDelegate: CXProviderDelegate {

    func providerDidReset(_ provider: CXProvider) {
        stopAudio()

        for call in callManager.calls {
            call.end()
        }

        callManager.removeAllCalls()
    }
}
