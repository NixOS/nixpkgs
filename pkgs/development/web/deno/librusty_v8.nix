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
  version = "0.41.0";
  shas = {
    x86_64-linux = "sha256-f5HWLe1wF6nA+e5SwWd+DwXtYnOrcXI8kLIwdi8scmg=";
    aarch64-linux = "sha256-tLCR1CBeM+1vRThsJNtEtKH6iJluxdCfnbCNkQQjNfM=";
    x86_64-darwin = "sha256-KVBskUTr1SXL/hm9gnHvGGd3TO3QVESiZy0EYXDwPo0=";
    aarch64-darwin = "sha256-KjBO6cgibo98P8n1kiMIT1cJ7Aa6BnQeMku71j4sgZY=";
  };
}
