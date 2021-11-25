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
  version = "0.35.0";
  shas = {
    x86_64-linux = "sha256-vMqLxARbR39G7YSACvqxp+3WLDcfivDgMkvkAEtJ758=";
    aarch64-linux = "sha256-8rU4Z+eOt4RduiYM97uPiVLAspPkvmf7oeTVuVfBjII=";
    x86_64-darwin = "sha256-SIXXfK72FfwGv44Z+Qu+a5YAtUaqo/qEpMJZdpOdr3A=";
    aarch64-darwin = "sha256-FAzwPlST02O5b/T9cz+uKNp6GFhFrgQnmabrAjMfmWc=";
  };
}
