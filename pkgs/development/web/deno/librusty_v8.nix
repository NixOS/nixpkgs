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
  version = "0.85.0";
  shas = {
    x86_64-linux = "sha256-Ma6JewYaHuPLihKnwwq8pAo+6sraXMghnl+wMvRfP1Y=";
    aarch64-linux = "sha256-Y55ZXuyB2kq2a/cJwIo7DxClg2juAsGYpyTmwYE2W3Q=";
    x86_64-darwin = "sha256-njP3obzJxr8I4G3jhDNbiVL8Cxa9D4KPGXW7VFrAZQY=";
    aarch64-darwin = "sha256-/8UFpUgdSKihxd4qsBoxYFrjEKUG3cDSkwJ5NSdmSQs=";
  };
}
