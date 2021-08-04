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
        shareWhatsApp(message: "This the test message",result: result)
      }
    else if(call.method.elementsEqual("system")){
        let args = call.arguments as? Dictionary<String,Any>
        systemShare(message: args!["msg"] as! String,result: result)
    }
      else{
          result(FlutterMethodNotImplemented)
      }
  }
    
    
func shareWhatsApp(message:String, result: @escaping FlutterResult)  {
    let messageBody = "Hello"
        let whatsURL = "whatsapp://send?text=\(messageBody)"
    
    var characterSet = CharacterSet.urlQueryAllowed
    characterSet.insert(charactersIn: "?&")
    
//           let whatsAppURL  = NSURL(string: whatsURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
    let whatsAppURL  = NSURL(string: whatsURL.addingPercentEncoding(withAllowedCharacters: characterSet)!)
    if UIApplication.shared.canOpenURL(whatsAppURL! as URL)
        {
        UIApplication.shared.openURL(whatsAppURL! as URL)
            result("whats'app open");
        }
        else
        {
        result("Whatsapp is not installed on your phone");
        }}

    func systemShare(message:String,result: @escaping FlutterResult)  {
        // find the root view controller
        let viewController = UIApplication.shared.delegate?.window??.rootViewController
        
        // Here is the message for for sharing
        let objectsToShare = [message] as [Any]
           let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        /// if want to exlude anything then will add it for future support.
        //        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        viewController!.present(activityVC, animated: true, completion: nil)
        result("sucess");
    
        
    }
}
