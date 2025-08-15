import UIKit
import React
import React_RCTAppDelegate
import ReactAppDependencyProvider

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var reactNativeDelegate: ReactNativeDelegate?
    var reactNativeFactory: RCTReactNativeFactory?
    
    private var blurView: UIVisualEffectView?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let delegate = ReactNativeDelegate()
        let factory = RCTReactNativeFactory(delegate: delegate)
        delegate.dependencyProvider = RCTAppDependencyProvider()
        
        reactNativeDelegate = delegate
        reactNativeFactory = factory
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        factory.startReactNative(
            withModuleName: "iOChallenge",
            in: window,
            launchOptions: launchOptions
        )
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow } ) else { return }
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blur.frame = window.bounds
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        window.addSubview(blur)
        blurView = blur
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        blurView?.removeFromSuperview()
        blurView = nil
    }
    
}

class ReactNativeDelegate: RCTDefaultReactNativeFactoryDelegate {
    override func sourceURL(for bridge: RCTBridge) -> URL? {
        self.bundleURL()
    }
    
    override func bundleURL() -> URL? {
        #if DEBUG
        RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
        #else
        Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        #endif
    }
}
