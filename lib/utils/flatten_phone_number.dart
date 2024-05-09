String flattenPhoneNumber(String phoneStr) {
  return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
    return m[0] == "+" ? "+" : "";
  });
}
