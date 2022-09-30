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
  version = "0.51.0";
  shas = {
    x86_64-linux = "sha256-M6GrAHidz9OPVrNgqxoEmvRgbNMyWKV8xpSTMGvW6kI=";
    aarch64-linux = "sha256-gDC03Lku+biQGxa4vCOqhrGs7Js6BPbJFtqPDNxrpsQ=";
    x86_64-darwin = "sha256-uK6ytoRu1lHtqMiertICcaS3KN11iHhQmmIMhD2tCc0=";
    aarch64-darwin = "sha256-rNuQg78GsyErmcDOMn4PLIR1AzSQ6CbfqL7I67MlQQc=";
  };
}
