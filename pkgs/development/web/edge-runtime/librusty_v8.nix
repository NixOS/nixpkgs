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
  version = "0.83.2";
  shas = {
    x86_64-linux = "sha256-RJNdy5jRZK3dTgrHsWuZZAHUyy1EogyNNuBekZ3Arrk=";
    aarch64-linux = "sha256-mpOmuqtd7ob6xvrgH4P/6GLa/hXTS/ok0WOYo7+7ZhI=";
    x86_64-darwin = "sha256-2o8CvJ3r5+4PLNGTySqPPDTqbU0piX4D1UtZMscMdHU=";
    aarch64-darwin = "sha256-WHeITWSHjZxfQJndxcjsp4yIERKrKXSHFZ0UBc43p8o=";
  };
}
