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
  version = "0.97.0";
  shas = {
    x86_64-linux = "sha256-6dWSE9EsihouhRTEnly5UJFcKXwR7GhoYJtOvgVHhXk=";
    aarch64-linux = "sha256-8IkFEnzpGuDHfHkRuybZ7rLhxOcI2y1p+3jlV45eqho=";
    x86_64-darwin = "sha256-UmmgJH//lbqgQuhcL3NSaJnyaACZmLf8I5Gg/dubdh8=";
    aarch64-darwin = "sha256-L8CR4oSTnxP5wo3aIoVXmgXDp/FHAs45ErLtEcno9AU=";
  };
}
