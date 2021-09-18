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
  version = "0.28.0";
  shas = {
    x86_64-linux = "sha256-Kz2sAAUux1BcrU2vukGybSs+REAIRUWMxqZakRPEeic=";
    aarch64-linux = "sha256-QXj9y6NrvxU6oL9QO2dYH4Fz+MbTzON7w8sTCei7Mqs=";
    x86_64-darwin = "sha256-zW1g3DZ4Mh4j3UYE312dDkbX6ngg50GaKCHYPa6H0Dk=";
    aarch64-darwin = "sha256-hLIRxApjTbkfDVPhK3EC7X/p6uQK5kOEILZfAmFV5AA=";
  };
}
