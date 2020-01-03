package zhuoyuan.li.fluttershareme.util;

import android.content.Context;
import android.content.CursorLoader;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Base64;
import android.webkit.MimeTypeMap;

import androidx.core.content.FileProvider;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class FileUtil {

    private final String authorities;
    private final Context context;
    private String url;
    private String type;
    private Uri uri;

    public FileUtil(Context applicationContext, String url) {
        this.url = url;
        this.uri = Uri.parse(this.url);
        this.context = applicationContext;
        authorities = applicationContext.getPackageName() + ".provider";
    }

    private String getMimeType(String url) {
        String type = null;
        String extension = MimeTypeMap.getFileExtensionFromUrl(url);
        if (extension != null) {
            type = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
        }
        return type;
    }

    public boolean isFile() {
        return isBase64File() || isLocalFile();
    }

    private boolean isBase64File() {
        String scheme = uri.getScheme();
        if (scheme != null && uri.getScheme().equals("data")) {
            type = uri.getSchemeSpecificPart().substring(0, uri.getSchemeSpecificPart().indexOf(";"));
            return true;
        }
        return false;
    }

    private boolean isLocalFile() {
        String scheme = uri.getScheme();
        if (scheme != null && (uri.getScheme().equals("content") || uri.getScheme().equals("file"))) {
            if (type != null) {
                return true;
            }
            type = getMimeType(uri.toString());
            if (type == null) {
                String realPath = getRealPath(uri);
                if (realPath == null) {
                    return false;
                } else {
                    type = getMimeType(realPath);
                }

                if (type == null) {
                    type = "*/*";
                }
            }
            return true;
        }
        return false;
    }

    public String getType() {
        if (type == null) {
            return "*/*";
        }
        return type;
    }

    private String getRealPath(Uri uri) {
        String[] projection = {MediaStore.Images.Media.DATA};
        CursorLoader loader = new CursorLoader(context, uri, projection, null, null, null);
        Cursor cursor = loader.loadInBackground();
        String result = null;
        if (cursor != null && cursor.moveToFirst()) {
            int col_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
            result = cursor.getString(col_index);
            cursor.close();
        }
        return result;
    }

    public Uri getUri() {
        final MimeTypeMap mime = MimeTypeMap.getSingleton();
        String extension = mime.getExtensionFromMimeType(getType());

        if (isBase64File()) {
            final String tempPath = context.getCacheDir().getPath();
            final String prefix = "" + System.currentTimeMillis() / 1000;
            String encodedFile = uri.getSchemeSpecificPart()
                    .substring(uri.getSchemeSpecificPart().indexOf(";base64,") + 8);
            try {
                File tempFile = new File(tempPath, prefix + "." + extension);
                final FileOutputStream stream = new FileOutputStream(tempFile);
                stream.write(Base64.decode(encodedFile, Base64.DEFAULT));
                stream.flush();
                stream.close();
                return FileProvider.getUriForFile(context, authorities, tempFile);
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else if (isLocalFile()) {
            Uri uri = Uri.parse(this.url);
            return FileProvider.getUriForFile(context, authorities, new File(uri.getPath()));
        }
        return null;
    }
}