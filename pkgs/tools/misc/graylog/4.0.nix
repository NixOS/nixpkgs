{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "4.0.8";
  sha256 = "sha256-1JlJNJSU1wJiztLhYD87YM/7p3YCBXBKerEo/xfumUg=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
