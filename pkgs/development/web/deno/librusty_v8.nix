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
  version = "0.32.0";
  shas = {
    x86_64-linux = "sha256-35Rm4j4BJNCfl3MQJIpKw1altzm9fgvZ6WeC2cF4Qzc=";
    aarch64-linux = "sha256-w1ljFwao/YMO27QSaEyVl7HEVnfzZyVOXZK4xN0205Y=";
    x86_64-darwin = "sha256-oNrF9lFkgMgphDElKQRXMq9uYua75e2HrfflNO+CyPk=";
    aarch64-darwin = "sha256-Bz9C1AChvGJYamnIg1XtYyTzmIisL0Oe/yDjB7ZebMw=";
  };
}
