/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class CallTableViewCell: UITableViewCell {

    var callState: CallState? {
        didSet {
            guard let callState = callState else { return }

            switch callState {
            case .active:
                callStatusLabel.text = "Active"
            case .held:
                callStatusLabel.text = "On Hold"
            case .connecting:
                callStatusLabel.text = "Connecting..."
            default:
                callStatusLabel.text = "Dialing..."
            }
        }
    }
    
    var incoming: Bool = false {
        didSet {
            // statement uses image literals for incoming_arrow and outgoing_arrow
            iconImageView.image = incoming ? #imageLiteral(resourceName: "incoming_arrow") : #imageLiteral(resourceName: "outgoing_arrow")
        }
    }

    var callerHandle: String? {
        didSet {
            callerHandleLabel.text = callerHandle
        }
    }

    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var callerHandleLabel: UILabel!
    @IBOutlet private var callStatusLabel: UILabel!
}
