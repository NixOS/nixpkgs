# auto-generated file -- DO NOT EDIT!
{ lib, stdenv, fetchurl }:

let
  fetch_librusty_v8 = args: fetchurl {
    name = "librusty_v8-${args.version}";
    url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
    sha256 = args.shas.${stdenv.hostPlatform.system};
    meta = {
      inherit (args) version;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  };
in
fetch_librusty_v8 {
  version = "0.99.0";
  shas = {
    x86_64-linux = "sha256-rXAxKDTDB7tU5T6tf7XQUEAbDD2PXfzU+0bgA6WOsOQ=";
    aarch64-linux = "sha256-4V3EtxH+rGsJzam57OByLlB0D1xtnSz+1P34EfaIry4=";
    x86_64-darwin = "sha256-fYo8B9uMS6ElPA+4A3wLQvuLH2dqar6hGhpOTvnKK7s=";
    aarch64-darwin = "sha256-vh/fitDe3s0AoncO9nlJPNTMLQhWuJnYzFHsYdmERrU=";
  };
}
