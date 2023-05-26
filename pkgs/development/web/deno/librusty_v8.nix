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
  version = "0.72.0";
  shas = {
    x86_64-linux = "sha256-APF8pCLLJ2m2XdvsecEQu5HBuNZx+WO/qRGdwogZi10=";
    aarch64-linux = "sha256-clhSbml1qnPGEU6KfhVouIHqWTWjZeN6xLw+AIhHuKI=";
    x86_64-darwin = "sha256-2pEpeDJucUIOY0pOpbaUAKW4is7A1Axz+ZDhDSiIEa8=";
    aarch64-darwin = "sha256-BL9u5nS0okQyLzLWJh70vyqBoSGW6bJaYzxeCNHGBwg=";
  };
}
