
import UIKit

@objc open class JLToastCenter: NSObject {

    fileprivate var _queue: OperationQueue!

    fileprivate struct Singletone {
        static let defaultCenter = JLToastCenter()
    }
    
    open class func defaultCenter() -> JLToastCenter {
        return Singletone.defaultCenter
    }
    
    override init() {
        super.init()
        self._queue = OperationQueue()
        self._queue.maxConcurrentOperationCount = 1
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(JLToastCenter.deviceOrientationDidChange(_:)),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil
        )
    }
    
    open func addToast(_ toast: JLToast) {
        self._queue.addOperation(toast)
    }
    
    func deviceOrientationDidChange(_ sender: AnyObject?) {
        if self._queue.operations.count > 0 {
            let lastToast: JLToast = _queue.operations[0] as! JLToast
            lastToast.view.updateView()
        }
    }
}
