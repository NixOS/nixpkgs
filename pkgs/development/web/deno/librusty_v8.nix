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
  version = "0.22.2";
  shas = {
    x86_64-linux = "sha256-bLGSt9a+drzXMy64iiERFHfdDsIR2YqwwNlkpzIM07Q=";
    aarch64-linux = "sha256-MtCB7XaFho+a64fidPO88URIq7X9HvGqN5a9hzuCX4s=";
    x86_64-darwin = "sha256-aLeZ0cIdmQHDxSGPx6IBwweZWwDI/m/1kFQTC7dQ3bs=";
    aarch64-darwin = "sha256-SZGx/kRvp88mfMqDX+d4GNDs4t+P383kjnNPqwkqkHI=";
  };
}
