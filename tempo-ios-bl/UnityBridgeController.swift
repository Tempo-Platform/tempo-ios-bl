import Foundation

public class UnityBridgeController: NSObject
{
    // Delelgates
    var onInit: (() -> Void)?
    var onConsentTypeConfirmed: ((UnsafePointer<CChar>?) -> Void)?
    var onCountryCodeConfirmed: ((UnsafePointer<CChar>?) -> Void)?
    var onAdIdConfirmed: ((UnsafePointer<CChar>?) -> Void)?
    var onLocDataSuccess: ((UnsafePointer<CChar>?, UnsafePointer<CChar>?, UnsafePointer<CChar>?, 
                            UnsafePointer<CChar>?,UnsafePointer<CChar>?, UnsafePointer<CChar>?,
                            UnsafePointer<CChar>?, UnsafePointer<CChar>?, UnsafePointer<CChar>?) -> Void)?
    var onLocDataFailure: ((UnsafePointer<CChar>?, UnsafePointer<CChar>?, UnsafePointer<CChar>?,
                            UnsafePointer<CChar>?, UnsafePointer<CChar>?, UnsafePointer<CChar>?,
                            UnsafePointer<CChar>?, UnsafePointer<CChar>?, UnsafePointer<CChar>?) -> Void)?
    var onVersionCodeConfirmed: ((UnsafePointer<CChar>?) -> Void)?
    var onVersionNameConfirmed: ((UnsafePointer<CChar>?) -> Void)?
    var onSomething: ((UnsafePointer<CChar>?, Int) -> Void)?
    
    // Bridge properties
    var bridge: UnityBridgeController? // go-between
    var profile: Profile? // user data collection
    public var countryCode: String = ""
    
    /// First step to set core basic that will ve used throughout session
    override init() {   /* Nothing needs to happen here */ }
    
    /// Initialises mediator class and get cc straight away
    func initBridge(bridgeController: UnityBridgeController) {
        print("💥 UnityBridgeController.initBridge()")
        bridge = bridgeController
        getCountryCode()
        onInit?()
    }
    
    /// Starts process of collecting user profiling data (location, Ad ID etc)
    func createProfile() {
        print("💥 UnityBridgeController.createProfile()")
        profile = Profile(bridgeController: bridge!)
        getAdId()
        getVersionData()
        profile?.doTaskAfterLocAuthUpdate(completion: nil)
    }
    
    /// Returns Ad ID, if setup on user's device
    func getAdId() {
        let adId = profile?.getAdId() ?? BridgeRef.ZERO_AD_ID
        print("💥 UnityBridgeController.getAdId() -> \(adId)")
        onAdIdConfirmed?(adId)
    }
    
    /// Returns Ad ID, if setup on user's device
    func getVersionData() {
        print("🧨 getVersionData triggered!")
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            print("🌟 Version: \(version), Build: \(build)")
            onVersionNameConfirmed?(version)
            onVersionCodeConfirmed?(build)
        }
        
        if let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            print("🌀 App Version: \(appVersion)")
            onVersionNameConfirmed?(appVersion)
        }
        
        if let buildVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
            print("🍀 Build Version: \(buildVersion)")
            onVersionCodeConfirmed?(buildVersion)
        }
        
        /*
         
         CFBundleShortVersionString:

         This is the Marketing Version key.
         Represents the version number seen by users (e.g., 1.2.0).
         This key is meant to follow the semantic versioning format (Major.Minor.Patch).
         Official Apple Reference: CFBundleShortVersionString.
         CFBundleVersion:

         This is the Build Version key.
         Represents the internal build number (e.g., 123).
         This key can be any string but is often a sequential build number.
         Official Apple Reference: CFBundleVersion.
         
         */
    }
    
    /// Returns 2-digit ISO country code from device settings
    func getCountryCode() {
        countryCode = CountryCode.getIsoCountryCode2Digit() ?? ""
        print("💥 UnityBridgeController.getCountryCode() -> \(countryCode)")
        onCountryCodeConfirmed?(BridgeUtils.charPointerConverter(countryCode))
    }
    
    /// Test function to send back String/Int to Unity
    func sendSomethingToUnity(someString: UnsafePointer<CChar>?, someInt: Int) {
        if let onSomething = bridge?.onSomething {
            print("something => \(someInt))")
            onSomething(someString, someInt)
        } else {
            print("Error: onSomething is nil")
        }
    }
    
    /// Test function to send back String/Int to Unity
    func requestLocationConsent() {
        profile?.requestLocationConsentNowAsTesting()
    }
}
