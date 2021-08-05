import Flutter
import UIKit
import FacebookShare
public class SwiftFlutterShareMePlugin: NSObject, FlutterPlugin, SharingDelegate {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_share_me", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterShareMePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method.elementsEqual("shareWhatsApp")){
            shareWhatsApp(message: "This the test message",result: result)
        }
        else if(call.method.elementsEqual("shareWhatsApp4Biz")){
            let args = call.arguments as? Dictionary<String,Any>
            ///whatsapp business is underworking
            shareWhatsApp4Biz(message: args!["msg"] as! String, result: result)
        }
        else if(call.method.elementsEqual("shareFacebook")){
            let args = call.arguments as? Dictionary<String,Any>
            sharefacebook(message: args, result: result)
        }else if(call.method.elementsEqual("shareTwitter")){
            let args = call.arguments as? Dictionary<String,Any>
            shareTwitter   (message: args!["msg"] as! String, result: result)
        }
        else{
            let args = call.arguments as? Dictionary<String,Any>
            systemShare(message: args!["msg"] as! String,result: result)
        }
        
    }
    
    
    func shareWhatsApp(message:String, result: @escaping FlutterResult)  {
        let whatsURL = "whatsapp://send?text=\(message)"
        
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        
        //  let whatsAppURL  = NSURL(string: whatsURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        let whatsAppURL  = NSURL(string: whatsURL.addingPercentEncoding(withAllowedCharacters: characterSet)!)
        if UIApplication.shared.canOpenURL(whatsAppURL! as URL)
        {
            result("true");
            UIApplication.shared.openURL(whatsAppURL! as URL)
            
        }
        else
        {
            result(FlutterError(code: "Not found", message: "WhatsApp is not found", details: "WhatsApp not intalled or Check URLSchme."));
        }
        
    }
    
    func shareWhatsApp4Biz(message:String, result: @escaping FlutterResult)  {
        //        let whatsApp = "whatsapp://send?text=\(message)"
        let whatsApp = "https://wa.me/?text=\(message)"
        
        
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        
        //  let whatsAppURL  = NSURL(string: whatsURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        let whatsAppURL  = NSURL(string: whatsApp.addingPercentEncoding(withAllowedCharacters: characterSet)!)
        if UIApplication.shared.canOpenURL(whatsAppURL! as URL)
        {
            result("true");
            UIApplication.shared.openURL(whatsAppURL! as URL)
        }
        else
        {
            result(FlutterError(code: "Not found", message: "WhatsApp is not found", details: "WhatsApp not intalled or Check URLSchme."));
        }
    }
    
    func sharefacebook(message:Dictionary<String,Any>, result: @escaping FlutterResult)  {
        let viewController = UIApplication.shared.delegate?.window??.rootViewController
        let shareContent = ShareLinkContent()
        shareContent.contentURL = URL.init(string: message["url"])!
        shareContent.quote = message["msg"]
        ShareDialog(fromViewController: viewController, content: shareContent, delegate: self).show()
        
    }
    
    func shareTwitter(message:String, result: @escaping FlutterResult)  {
        
    }
    
    func systemShare(message:String,result: @escaping FlutterResult)  {
        // find the root view controller
        let viewController = UIApplication.shared.delegate?.window??.rootViewController
        
        // Here is the message for for sharing
        let objectsToShare = [message] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        /// if want to exlude anything then will add it for future support.
        //        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        viewController!.present(activityVC, animated: true, completion: nil)
        result("true");
        
        
    }
    
    
    ///Facebook delegate methods
    
    public func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        if sharer.shareContent.pageID != nil {
            print("Share: Success")
        }
    }
    
    public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Share: Fail")
        
    }
    
    public func sharerDidCancel(_ sharer: Sharing) {
        print("Share: Cancel")
    }
}
