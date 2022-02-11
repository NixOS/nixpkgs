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
  version = "0.38.1";
  shas = {
    x86_64-linux = "sha256-vRkb5ZrIOYSKa84UbsJD+Oua0wve7f1Yf3kMg/kkYSY=";
    aarch64-linux = "sha256-o9btdXct/HpUTXlJc2Ydzj2yo2lSV87uo/VyxaxN0fk=";
    x86_64-darwin = "sha256-/J/MpXnzvBv70o8Zjc46yPzBrY309o4kDQ9kZzDfhb4=";
    aarch64-darwin = "sha256-y4MJIA2HKPm9iLJSxDw43VHsoY5v2WGp7zEsll/EHhI=";
  };
}
