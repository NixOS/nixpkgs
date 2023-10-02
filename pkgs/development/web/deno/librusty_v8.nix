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
  version = "0.78.0";
  shas = {
    x86_64-linux = "sha256-1df7bH3ZdgIasZvvNH3iKQ4lmcGNq6ldgMV9nDgOC14=";
    aarch64-linux = "sha256-riSyGvOGwqL1hSAXpUvBju/3DN20THtg0NuIzn1m1M8=";
    x86_64-darwin = "sha256-4Nnkrj9GfliYUInb7SssqzFIDbV0XVxdEBC28klqBDM=";
    aarch64-darwin = "sha256-oepRKVb05zAUeZo2RN3Vca0CUQ+Fd1duIU3xOG+FEJw=";
  };
}
