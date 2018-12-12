package zhuoyuan.li.fluttershareme;


import android.app.Activity;
import android.content.Intent;
import android.net.Uri;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;
import com.twitter.sdk.android.tweetcomposer.TweetComposer;

import java.net.MalformedURLException;
import java.net.URL;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterShareMePlugin */
public class FlutterShareMePlugin implements MethodCallHandler {
  /** Plugin registration. */
  private Activity activity;
  private static CallbackManager callbackManager;

  private FlutterShareMePlugin(MethodChannel channel, Activity activity) {
    MethodChannel _channel = channel;
    this.activity = activity;
    _channel.setMethodCallHandler(this);
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_share_me");
    channel.setMethodCallHandler(new FlutterShareMePlugin(channel, registrar.activity()));
    callbackManager = CallbackManager.Factory.create();
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    String url, msg;

    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "shareFacebook":
        url = call.argument("url");
        msg = call.argument("msg");
        shareToFacebook(url, msg, result);
        break;
      case "shareTwitter":
        url = call.argument("url");
        msg = call.argument("msg");
        shareToTwitter(url, msg, result);
        break;
      case "shareWhatsApp":
        msg = call.argument("msg");
        shareWhatsApp(msg, result);
        break;
      case "system":
        msg = call.argument("msg");
        shareSystem(result, msg);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void shareSystem(Result result, String msg) {
    try {
      Intent textIntent = new Intent("android.intent.action.SEND");
      textIntent.setType("text/plain");
      textIntent.putExtra("android.intent.extra.TEXT", msg);
      activity.startActivity(Intent.createChooser(textIntent, "Share to"));
      result.success("success");
    } catch (Exception var7) {
      result.error("error", var7.toString(), "");
    }
  }

  private void shareToTwitter(String url, String msg, Result result) {
    //这里分享一个链接，更多分享配置参考官方介绍：https://dev.twitter.com/twitterkit/android/compose-tweets
    try {
      TweetComposer.Builder builder = new TweetComposer.Builder(activity)
              .text(msg);
      if (url != null && url.length() > 0) {
        builder.url(new URL(url));
      }

      builder.show();
      result.success("success");
    } catch (MalformedURLException e) {
      e.printStackTrace();
    }
  }

  private void shareToFacebook(String url, String msg, Result result) {
    FacebookSdk.setApplicationId("343254889799245");
    FacebookSdk.sdkInitialize(activity.getApplicationContext());
    ShareDialog shareDialog = new ShareDialog(activity);
    // this part is optional
    shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
      @Override
      public void onSuccess(Sharer.Result result) {
        System.out.println("--------------------success");
      }

      @Override
      public void onCancel() {
        System.out.println("-----------------onCancel");
      }

      @Override
      public void onError(FacebookException error) {
        System.out.println("---------------onError");
      }
    });

    ShareLinkContent content = new ShareLinkContent.Builder()
            .setContentUrl(Uri.parse(url))
            .setQuote(msg)
            .build();
    if (ShareDialog.canShow(ShareLinkContent.class)) {
      shareDialog.show(content);
      result.success("success");
    }

  }

  private void shareWhatsApp(String msg, Result result) {
    try {
      Intent textIntent;
      textIntent = new Intent("android.intent.action.SEND");
      textIntent.setType("text/plain");
      textIntent.setPackage("com.whatsapp");
      textIntent.putExtra("android.intent.extra.TEXT", msg);
      activity.startActivity(textIntent);
      result.success("success");
    } catch (Exception var9) {
      result.error("error", var9.toString(), "");
    }
  }
}
