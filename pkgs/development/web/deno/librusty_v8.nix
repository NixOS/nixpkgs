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
  version = "0.34.0";
  shas = {
    x86_64-linux = "sha256-Ly5bEfC993JH3/1VNpFu72Dv8kJYOFu+HIlEUJJcHps=";
    aarch64-linux = "sha256-zazlvm4uyHD6Z+2JmeHS7gQ84C83KTWOGqNjSNPgoT0=";
    x86_64-darwin = "sha256-RTgbtkCAuIj/ceJNbdA0yfKtFG8hSZgurEHEuUfJ7fk=";
    aarch64-darwin = "sha256-xrOUPEZ4tj2BK6pDeoTpTKDx4E1KUEQ+lGMyduKDvBE=";
  };
}
