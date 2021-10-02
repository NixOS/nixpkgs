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
  version = "0.30.0";
  shas = {
    x86_64-linux = "sha256-p5Vbt2fQPFR9SfLJ03f62/a8o9QIJOTXbA1s2liwNXY=";
    aarch64-linux = "sha256-j12KjdnL19d5U/QRfB/7ahUzcYnUddItp29bLM/mWzs=";
    x86_64-darwin = "sha256-w3k9oj+mP+i/hSf+ZjYLF+zsAcyLezbxhWXYoaPpn+U=";
    aarch64-darwin = "sha256-bOtZoG8vXnSBNTPJDkyW0xbMEbmGNtq+mEPKoP78Yew=";
  };
}
