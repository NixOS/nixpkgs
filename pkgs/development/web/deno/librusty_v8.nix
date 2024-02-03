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
  version = "0.83.1";
  shas = {
    x86_64-linux = "sha256-0cCpFMPpFWTvoU3+HThYDDTQO7DdpdVDDer5k+3HQFY=";
    aarch64-linux = "sha256-fOyJiD0raHxl+5tDWSpH/MbdBUqNY+HCKmTulYLXEYI=";
    x86_64-darwin = "sha256-JwZ1FrU/MZeEnvSPDojvDdDxIF/bdZBPRCXrjbBb7WM=";
    aarch64-darwin = "sha256-ajmr+SGj3L8TT+17NPkNcwQFESpIZuUul12Pp1oJAkY=";
  };
}
