{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "17.1.0";
  sha256 = "1iyazwpgv3pxqh7zz3s87qwrbahifrj9sj1a2vwhkc4jxcvkz03b";
  patches = [ ./disable-darwin-v8-system-instrumentation.patch ];
}
