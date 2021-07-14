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
  version = "0.25.3";
  shas = {
    x86_64-linux = "sha256-Z3lEJT3QVhP8PoDiM6Fw0sm5rXWvasBqASBO5tZA5zM=";
    aarch64-linux = "sha256-pbcd1zV7IIEqCIp8vsRiO0KBGrOv52SvMZ4gthxuN/I=";
    x86_64-darwin = "sha256-BwYdgd1kK8EQFfDc9RgtNvwvx7agt9hYNVmBGwHoqz0=";
    aarch64-darwin = "sha256-/RHeNuR7VjhfwdjZXWMMX3UnweAjJblSCUq9eIwGvWc=";
  };
}
