import Flutter
import UIKit

public class SwiftFlutterShareMePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_share_me", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterShareMePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method.elementsEqual("shareWhatsApp")){
          
      }
      else{
          result(FlutterMethodNotImplemented)
      }
  }
    
    
    func shareWhatsApp(<#parameters#>) -> <#return type#> {
        <#function body#>
    }
}
