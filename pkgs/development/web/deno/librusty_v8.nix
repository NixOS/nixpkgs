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
  version = "0.63.0";
  shas = {
    x86_64-linux = "sha256-D1NLAFMD1B4NOaBFsKBin5Gs+hmNC9LgNy3Z+w/1VGs=";
    aarch64-linux = "sha256-3V2WWMCjJNiuCRmx66ISBk+pzvCKCqvOE9F3YWESABo=";
    x86_64-darwin = "sha256-rUWSHxlFDT4cDoTLhSgRr04+2/oroeIiWURHbNDcMF8=";
    aarch64-darwin = "sha256-LaoIjHrBqWn0BIpAOaiHAg5qCGoPlSHtFhiAi4og9q0=";
  };
}
