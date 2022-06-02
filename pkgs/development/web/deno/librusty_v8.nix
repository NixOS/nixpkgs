# auto-generated file -- DO NOT EDIT!
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
  version = "0.42.1";
  shas = {
    x86_64-linux = "sha256-rAqIkJ85l5eSojTowVZl5waK/fk00JI4fI1AY1ue/i4=";
    aarch64-linux = "sha256-uGptQ5V4u6Vz5BI9xmMShB3gnIUjvA/LKeh+kj71XK8=";
    x86_64-darwin = "sha256-Hcb4Vct9aTv4APJfNpydRY68jpEE3wZVctKhURohz4Y=";
    aarch64-darwin = "sha256-OSrbI7pX9arCJt8ymRLEARo8admPDHvpDLqf3+iYzVQ=";
  };
}
