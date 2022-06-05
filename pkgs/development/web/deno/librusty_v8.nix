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
  version = "0.43.1";
  shas = {
    x86_64-linux = "sha256-xsKV3/MXwQExON5Bq1qRUShPV0wXEtUHB/DTVjVyWfQ=";
    aarch64-linux = "sha256-wBtpDG4GxSR4jeAZjclNqVDankWBmxf0cH0LKM4smjM=";
    x86_64-darwin = "sha256-BGrbwRoPUcSIW4Q3PF8p6vjkTKGLISBxLjOXDWcSjag=";
    aarch64-darwin = "sha256-4OyQPQPIQ94TanY1hxRTdcWZi5didvyLupLfQ516YL4=";
  };
}
