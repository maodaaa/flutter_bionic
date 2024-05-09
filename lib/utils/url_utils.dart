class UrlUtils {
  static String removeAfterLastExtension(String url) {
    int dotIndex = url.lastIndexOf(".");
    if (dotIndex != -1) {
      return url.substring(0, dotIndex + 4);
    } else {
      return url;
    }
  }
}
