import Flutter
import UIKit
import FacebookShare
import FacebookCore
public class SwiftFlutterShareMePlugin: NSObject, FlutterPlugin, SharingDelegate {
    var result: FlutterResult?
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_share_me", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterShareMePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        if(call.method.elementsEqual("shareWhatsApp")){
            let args = call.arguments as? Dictionary<String,Any>
            
            if args!["url"] as! String == "" {
                // if don't pass url then pass blank so if can strat normal whatsapp
                shareWhatsApp(message: args!["msg"] as! String,imageUrl: "",result: result)
            }else{
                // if user pass url then use that
                shareWhatsApp(message: args!["msg"] as! String,imageUrl: args!["url"] as! String,result: result)
            }
            
        }
        else if(call.method.elementsEqual("shareWhatsApp4Biz")){
            let args = call.arguments as? Dictionary<String,Any>
            ///whatsapp business is underworking
            if args!["url"]as! String == "" {
                // if don't pass url then pass blank so if can strat normal whatsapp
                shareWhatsApp4Biz(message: args!["msg"] as! String, result: result)
            }else{
                // if user pass url then use that
                shareWhatsApp(message: args!["msg"] as! String,imageUrl: args!["url"] as! String,result: result)
            }
        }
        else if(call.method.elementsEqual("shareFacebook")){
            let args = call.arguments as? Dictionary<String,Any>
            sharefacebook(message: args!, result: result)
            
        }else if(call.method.elementsEqual("shareTwitter")){
            let args = call.arguments as? Dictionary<String,Any>
            shareTwitter(message: args!["msg"] as! String, url: args!["url"] as! String, result: result)
        }
        else{
            let args = call.arguments as? Dictionary<String,Any>
            systemShare(message: args!["msg"] as! String,result: result)
        }
        
    }
    
    
    
    func shareWhatsApp(message:String, imageUrl:String,result: @escaping FlutterResult)  {
        let viewController = UIApplication.shared.delegate?.window??.rootViewController
        var whatsURL = ""
        if(imageUrl==""){
            whatsURL = "whatsapp://send?text=\(message)"
        }else{
            whatsURL = "whatsapp://app"
        }
        

        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        let whatsAppURL  = NSURL(string: whatsURL.addingPercentEncoding(withAllowedCharacters: characterSet)!)
        if UIApplication.shared.canOpenURL(whatsAppURL! as URL)
        {
            if(imageUrl==""){
                //mean user did not pass image url  so just got with text message
                result("Sucess");
                UIApplication.shared.openURL(whatsAppURL! as URL)
                
            }
            else{
                if let image = UIImage(named: imageUrl) {
                    if let imageData = image.jpegData(compressionQuality: 1.0) {
                        let tempFile = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai")
                        do {
                            try imageData.write(to: tempFile, options: .atomic)
                            let documentIC = UIDocumentInteractionController(url: tempFile)
                            documentIC.uti = "net.whatsapp.image"
                            documentIC.presentOpenInMenu(from: CGRect.zero, in: viewController!.view, animated: true)
                            result("Success")
                        }
                        catch {
                            print(error)
                        }
                    }
                }else{
                    result(FlutterError(code: "Not found", message: "This not image path", details: "Check image path."));
                }
            }
            
            
            
        }
        else
        {
            result(FlutterError(code: "Not found", message: "WhatsApp is not found", details: "WhatsApp not intalled or Check url scheme."));
        }
        
    }
    
    func shareWhatsApp4Biz(message:String, result: @escaping FlutterResult)  {
        let whatsApp = "https://wa.me/?text=\(message)"
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        
        let whatsAppURL  = NSURL(string: whatsApp.addingPercentEncoding(withAllowedCharacters: characterSet)!)
        if UIApplication.shared.canOpenURL(whatsAppURL! as URL)
        {
            result("Sucess");
            UIApplication.shared.openURL(whatsAppURL! as URL)
        }
        else
        {
            result(FlutterError(code: "Not found", message: "WhatsAppBusiness is not found", details: "WhatsAppBusiness not intalled or Check url scheme."));
        }
    }
    // share twitter
    // params
    // @ map conting meesage and url
    
    func sharefacebook(message:Dictionary<String,Any>, result: @escaping FlutterResult)  {
        let viewController = UIApplication.shared.delegate?.window??.rootViewController
        let shareDialog=ShareDialog()
        let shareContent = ShareLinkContent()
        shareContent.contentURL = URL.init(string: message["url"] as! String)!
        shareContent.quote = message["msg"] as? String
        shareDialog.mode = .automatic
        ShareDialog(fromViewController: viewController, content: shareContent, delegate: self).show()
        result("Sucess")
        
    }
    
    
    // share twitter params
    // @ message
    // @ url
    
    func shareTwitter(message:String,url:String, result: @escaping FlutterResult)  {
        let urlstring = url
        let twitterUrl =  "twitter://post?message=\(message)"
        
        let urlTextEscaped = urlstring.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url = URL(string: urlTextEscaped ?? "")
        
        let urlWithLink = twitterUrl + url!.absoluteString
        
        let escapedShareString = urlWithLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        // cast to an url
        let urlschme = URL(string: escapedShareString)
        // open in safari
       do {
            if UIApplication.shared.canOpenURL(urlschme! as URL){
                UIApplication.shared.openURL(urlschme!)
                result("Sucess")
            }else{
                result(FlutterError(code: "Not found", message: "Twitter is not found", details: "Twitter not intalled or Check url scheme."));
                
            }
        } catch  {
            result(FlutterError(code: "Not found", message: "Twitter is not found", details: "Twitter not intalled or Check url scheme."));
        }
        
        
        
    }
    
    
    func systemShare(message:String,result: @escaping FlutterResult)  {
        // find the root view controller
        let viewController = UIApplication.shared.delegate?.window??.rootViewController
        
        // Here is the message for for sharing
        let objectsToShare = [message] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        /// if want to exlude anything then will add it for future support.
        //        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popup = activityVC.popoverPresentationController {
                popup.sourceView = viewController?.view
                popup.sourceRect = CGRect(x: (viewController?.view.frame.size.width)! / 2, y: (viewController?.view.frame.size.height)! / 4, width: 0, height: 0)
            }
        }
        viewController!.present(activityVC, animated: true, completion: nil)
        result("Sucess");
        
        
    }
    
    
    ///Facebook delegate methods
    
    public func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print("Share: Success")
        
    }
    
    public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Share: Fail")
        
    }
    
    public func sharerDidCancel(_ sharer: Sharing) {
        print("Share: Cancel")
    }
}
