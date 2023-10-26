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
  version = "0.79.2";
  shas = {
    x86_64-linux = "sha256-efpB4BayPvB7KrP9v+U/jlS+Vs7QeURmPm5dnGmDD8Q=";
    aarch64-linux = "sha256-agtWSohMkkhxfKU+BQvHXomZSxVQLafma4IfiDO7vvo=";
    x86_64-darwin = "sha256-UWZAm7punliDUOOdD+vqZXpChyMXw5AMw8kgJ6nclzs=";
    aarch64-darwin = "sha256-p8lulv3E9A48nMH1KdROSY0L3Q/hqPVtTp9qIpUl1SM=";
  };
}
