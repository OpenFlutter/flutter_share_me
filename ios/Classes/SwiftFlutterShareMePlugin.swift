import Flutter
import UIKit
import FacebookShare
import FacebookCore

public class SwiftFlutterShareMePlugin: NSObject, FlutterPlugin, SharingDelegate {
    

    let _methodWhatsApp = "whatsapp_shar";
    let _methodWhatsAppPersonal = "whatsapp_personal";
    let _methodWhatsAppBusiness = "whatsapp_business_share";
    let _methodFaceBook = "facebook_share";
    let _methodTwitter = "twitter_share";
    let _methodSystemShare = "system_share";
    
    var result: FlutterResult?
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_share_me", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterShareMePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        if(call.method.elementsEqual(_methodWhatsApp)){
            let args = call.arguments as? Dictionary<String,Any>
            
            if args!["url"] as! String == "" {
                // if don't pass url then pass blank so if can strat normal whatsapp
                shareWhatsApp(message: args!["msg"] as! String,imageUrl: "",result: result)
            }else{
                // if user pass url then use that
                shareWhatsApp(message: args!["msg"] as! String,imageUrl: args!["url"] as! String,result: result)
            }
            
        }
        else if(call.method.elementsEqual(_methodWhatsAppBusiness)){
            let args = call.arguments as? Dictionary<String,Any>
            
            if args!["url"]as! String == "" {
                // if don't pass url then pass blank so if can strat normal whatsapp
                shareWhatsApp4Biz(message: args!["msg"] as! String, result: result)
            }else{
                // if user pass url then use that
                // wil open share sheet and user can select open for there.
                shareWhatsApp(message: args!["msg"] as! String,imageUrl: args!["url"] as! String,result: result)
            }
        }
        else if(call.method.elementsEqual(_methodWhatsAppPersonal)){
            let args = call.arguments as? Dictionary<String,Any>
              
            shareWhatsAppPersonal(message: args!["msg"]as! String, phoneNumber: args!["phoneNumber"]as! String, result: result)
        }
        else if(call.method.elementsEqual(_methodFaceBook)){
            let args = call.arguments as? Dictionary<String,Any>
            sharefacebook(message: args!, result: result)
            
        }else if(call.method.elementsEqual(_methodTwitter)){
            let args = call.arguments as? Dictionary<String,Any>
            shareTwitter(message: args!["msg"] as! String, url: args!["url"] as! String, result: result)
        }
        else{
            let args = call.arguments as? Dictionary<String,Any>
            systemShare(message: args!["msg"] as! String,result: result)
        }
    }
    
    
    func shareWhatsApp(message:String, imageUrl:String,result: @escaping FlutterResult)  {
    // @ for ios
    // we can't set both if you pass image then text will ignore
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
            //this is whats app work around so will open system share and exclude other share types
            let viewController = UIApplication.shared.delegate?.window??.rootViewController
            
            // if user share image then text will ignore because as of now there is no way to have both
            let image = UIImage(named: imageUrl)
            if let imageData = image!.jpegData(compressionQuality: 1.0) {
                // we we want to share image then image need to be in docuemnt folder so create new image in document folder and share that image.
                let tempFile = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai")
                do{
                    try imageData.write(to: tempFile, options: .atomic)
                    // image to be share
                    let imageToShare = [ tempFile]
                    
                    let activityVC = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
                    // we want to exlude most of the things so developer can see whatsapp only on system share sheet
                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop,UIActivity.ActivityType.message, UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.postToWeibo,UIActivity.ActivityType.print,UIActivity.ActivityType.openInIBooks,UIActivity.ActivityType.postToFlickr,UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.addToReadingList,UIActivity.ActivityType.copyToPasteboard]
                    
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        if let popup = activityVC.popoverPresentationController {
                            popup.sourceView = viewController?.view
                            popup.sourceRect = CGRect(x: (viewController?.view.frame.size.width)! / 2, y: (viewController?.view.frame.size.height)! / 4, width: 0, height: 0)
                        }
                    }
                    viewController!.present(activityVC, animated: true, completion: nil)
                    result("Sucess");
                    
                }
                catch {
                    print(error)
                }
            }
        }
        
    }
    else
    {
        result(FlutterError(code: "Not found", message: "WhatsApp is not found", details: "WhatsApp not intalled or Check url scheme."));
    }
}
    
    
    // Send whatsapp personal message
    // @ message
    // @ phone with contry code.
    func shareWhatsAppPersonal(message:String, phoneNumber:String,result: @escaping FlutterResult)  {
    
       let whatsURL = "whatsapp://send?phone=\(phoneNumber)&text=\(message)"
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        let whatsAppURL  = NSURL(string: whatsURL.addingPercentEncoding(withAllowedCharacters: characterSet)!)
        if UIApplication.shared.canOpenURL(whatsAppURL! as URL)
        {
            UIApplication.shared.openURL(whatsAppURL! as URL)
            result("Sucess");
        }else{
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
        
        
        // set up activity view controller
        
        
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
