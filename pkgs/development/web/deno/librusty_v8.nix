# auto-generated file -- DO NOT EDIT!
{ stdenv, fetchurl }:

let
  fetch_librusty_v8 = args: fetchurl {
    name = "librusty_v8-${args.version}";
    url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a";
    sha256 = args.shas.${stdenv.hostPlatform.system};
    meta = { inherit (args) version; };
  };
in
fetch_librusty_v8 {
  version = "0.82.0";
  shas = {
    x86_64-linux = "sha256-2nWOAUuzc7tr0KieeugIqI3zaRruvnLWBPn+ZdHTXsM=";
    aarch64-linux = "sha256-vlc60ZoFtT2Ugp0npT0dep6WWnEBAznR7dYFRaMNAKM=";
    x86_64-darwin = "sha256-CqyG/JOJe5kWzFJnnkU2Lz4VS/unWe1iucFxm+1HGsU=";
    aarch64-darwin = "sha256-ps19JZqCpO3pEAMQZOO+l/Iz7u0dIXLnpYIsnOyAxYk=";
  };
}
