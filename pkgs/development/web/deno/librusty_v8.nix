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
  version = "0.26.0";
  shas = {
    x86_64-linux = "sha256-eYvfsgkLuV//4NmnxTNgB5vGoQ2JdSpXwF34d1kNxBw=";
    aarch64-linux = "sha256-t+0/bJI4q2XElYz398aig/widJEOAascOmv4qnnKMQY=";
    x86_64-darwin = "sha256-lYJcx5Oe/nuF3l5coH4WIMbBbiFMwxNWlIYojrdiJfI=";
    aarch64-darwin = "sha256-5blisZ4Z/f68fZg7aDr5WK4MNvL5IRZZSJrvFb9N5oY=";
  };
}
