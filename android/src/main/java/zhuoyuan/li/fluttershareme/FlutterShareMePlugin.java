package zhuoyuan.li.fluttershareme;


import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
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
import zhuoyuan.li.fluttershareme.util.FileUtil;

/**
 * FlutterShareMePlugin
 */
public class FlutterShareMePlugin implements MethodCallHandler {

    private Activity activity;
    private static CallbackManager callbackManager;
    private Registrar registrar;


    /**
     * Plugin registration.
     */
    private FlutterShareMePlugin(Registrar registrar) {
        this.activity = registrar.activity();
        this.registrar = registrar;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_share_me");
        channel.setMethodCallHandler(new FlutterShareMePlugin(registrar));
        callbackManager = CallbackManager.Factory.create();
    }

    /**
     * method
     *
     * @param call   methodCall
     * @param result Result
     */
    @Override
    public void onMethodCall(MethodCall call, Result result) {
        String url, msg;
        switch (call.method) {
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
                url = call.argument("url");

                shareWhatsApp(url, msg, result);
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

    /**
     * system share
     *
     * @param msg    String
     * @param result Result
     */
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

    /**
     * share to twitter
     *
     * @param url    String
     * @param msg    String
     * @param result Result
     */
    private void shareToTwitter(String url, String msg, Result result) {
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

    /**
     * share to Facebook
     *
     * @param url    String
     * @param msg    String
     * @param result Result
     */
    private void shareToFacebook(String url, String msg, Result result) {

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

    /**
     * share to whatsapp
     *
     * @param msg    String
     * @param result Result
     */
    private void shareWhatsApp(String url, String msg, Result result) {
        try {
            Intent whatsappIntent = new Intent(Intent.ACTION_SEND);
            whatsappIntent.setType("text/plain");
            whatsappIntent.setPackage("com.whatsapp");
            whatsappIntent.putExtra(Intent.EXTRA_TEXT, msg);

            if (!TextUtils.isEmpty(url)) {
                FileUtil fileHelper = new FileUtil(registrar, url);
                if (fileHelper.isFile()) {
                    whatsappIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                    whatsappIntent.putExtra(Intent.EXTRA_STREAM, fileHelper.getUri());
                    whatsappIntent.setType(fileHelper.getType());
                }
            }
            whatsappIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            activity.startActivity(whatsappIntent);
            result.success("success");
        } catch (Exception var9) {
            result.error("error", var9.toString(), "");
        }
    }


}
