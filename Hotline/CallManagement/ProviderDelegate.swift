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
