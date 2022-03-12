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
  version = "0.40.2";
  shas = {
    x86_64-linux = "sha256-RtEKNDQdL0orI0B4953RaT18KeWPZJIdhPnYbJGj2eM=";
    aarch64-linux = "sha256-TL5boy1X/OgOt17H6PYEA5D3MJbChCULrB38ykC5Ghk=";
    x86_64-darwin = "sha256-ABnHMABtggrHoTjeFB8YVH6PV2HvVlPZTQWaeRnRZaE=";
    aarch64-darwin = "sha256-PGrRmNJxS49K9jviQTxRJlTq1SAn+8epXXNJaexTAWU=";
  };
}
