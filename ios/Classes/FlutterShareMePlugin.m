#import "FlutterShareMePlugin.h"

@implementation FlutterShareMePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_share_me"
                                     binaryMessenger:[registrar messenger]];
    FlutterShareMePlugin* instance = [[FlutterShareMePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"shareFacebook" isEqualToString:call.method]) {
        [self shareToFacebook: call.arguments[@"url"] message: call.arguments[@"msg"] result:result];
    } else if ([@"shareTwitter" isEqualToString:call.method]) {
        [self shareToTwitter: call.arguments[@"url"] message: call.arguments[@"msg"] result:result];
    } else if ([@"shareWhatsApp" isEqualToString:call.method]) {
        [self shareToWhatsApp:call.arguments[@"msg"] result:result];
    } else if ([@"shareWeChat" isEqualToString:call.method]) {
        [self shareToWeChat:call.arguments[@"msg"] result:result];
    } else if ([@"system" isEqualToString:call.method]) {
        [self shareViaSystem:call.arguments[@"msg"] result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)shareToFacebook: (NSString *)url message: (NSString *) msg result:(FlutterResult)result {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:url];
    content.quote = msg;
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    [FBSDKShareDialog showFromViewController:vc
                                 withContent:content
                                    delegate:nil];
    result(nil);
}

- (void)shareToTwitter: (NSString *)url message: (NSString *) msg result:(FlutterResult)result {
    msg = [msg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@&url=%@", msg ,url]];
    if ([[UIApplication sharedApplication] canOpenURL:nsUrl]) {
        [[UIApplication sharedApplication] openURL:nsUrl];
    }
    result(nil);
}

- (void)shareToWhatsApp: (NSString *) msg result:(FlutterResult)result {
    msg = [msg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@", msg]];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:whatsappURL options:@{}
           completionHandler:^(BOOL success) {
        }];
    } else {
        BOOL success = [application openURL:whatsappURL];
        if (success) result(@"success");
        result(@"error");
    }
}

- (void)shareToWeChat: (NSString *) msg result:(FlutterResult)result {
    NSArray *objectsToShare = @[msg];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypeCopyToPasteboard,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeMessage,
                                   UIActivityTypeMail,
                                   UIActivityTypePostToTwitter];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    [controller presentViewController:activityVC animated:YES completion:nil];
    result(nil);
}

- (void)shareViaSystem: (NSString *) msg result:(FlutterResult)result {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[ msg ]
                                      applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = controller.view;
    //    if (!CGRectIsEmpty(origin)) {
    //        activityViewController.popoverPresentationController.sourceRect = origin;
    //    }
    [controller presentViewController:activityViewController animated:YES completion:nil];
    result(nil);
}

@end
