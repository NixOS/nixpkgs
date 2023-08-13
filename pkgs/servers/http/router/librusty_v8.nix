{ rust, stdenv, fetchurl }:

let
  arch = rust.toRustTarget stdenv.hostPlatform;
  fetch_librusty_v8 = args: fetchurl {
    name = "librusty_v8-${args.version}";
    url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${arch}.a";
    sha256 = args.shas.${stdenv.hostPlatform.system};
    meta = { inherit (args) version; };
  };
in
fetch_librusty_v8 {
  version = "0.60.1";
  shas = {
    x86_64-linux = "sha256-P8H+XJqrt9jdKM885L1epMldp+stwmEw+0Gtd2x3r4g=";
    aarch64-linux = "sha256-frHpBP2pL3o4efFLHP2r3zsWJrNT93yYu2Qkxv+7m8Y=";
    x86_64-darwin = "sha256-taewoYBkyikqWueLSD9dW1EDjzkV68Xplid1UaLZgRM=";
    aarch64-darwin = "sha256-s2YEVbuYpiT/qrmE37aXk13MetrnJo6l+s1Q2y6b5kU=";
  };
}
