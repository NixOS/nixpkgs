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
  version = "0.105.0";
  shas = {
    x86_64-linux = "sha256-9yON4DNPxm4IUZSLZp9VZtzSRPPWX1tEuQLVJmN8cLs=";
    aarch64-linux = "sha256-5vAjw2vimjCHKPxjIp5vcwMCWUUDYVlk4QyOeEI0DLY=";
    x86_64-darwin = "sha256-o4WRkg4ptiJTNMkorn5K+P8xOJwpChM5PqkZCjP076g=";
    aarch64-darwin = "sha256-ZuWBnvxu1PgDtjtguxtj3BhFO01AChlbjAS0kZUws3A=";
  };
}
