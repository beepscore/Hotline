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

    fileprivate let callManager: CallManager
    fileprivate let provider: CXProvider

    init(callManager: CallManager) {
        self.callManager = callManager
        provider = CXProvider(configuration: type(of: self).providerConfiguration)

        super.init()

        provider.setDelegate(self, queue: nil)
    }

    // static var belongs to the type
    // subclasses can't override static
    static var providerConfiguration: CXProviderConfiguration {
        // initialize
        let providerConfiguration = CXProviderConfiguration(localizedName: "Hotline")

        // set call capabilities
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

    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        startAudio()
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {

        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }

        configureAudioSession()
        call.answer()
        // when processing an action, app should fulfill it or fail
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {

        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }

        stopAudio()
        // call.end changes the call's status, allows other classes to react to new state
        call.end()
        action.fulfill()
        callManager.remove(call: call)
    }

    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }

        call.state = action.isOnHold ? .held : .active

        if call.state == .held {
            stopAudio()
        } else {
            startAudio()
        }

        action.fulfill()
    }
}
