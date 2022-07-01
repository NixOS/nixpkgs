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
  version = "0.44.2";
  shas = {
    x86_64-linux = "sha256-I1ad9a9FtJGGGW7Odc8HfysQyCEAb8xoEYmYti0pEkE=";
    aarch64-linux = "sha256-KHjVMI9qiJ6q3D6t6iUKxbp1qthHSSl+2AfvL3Hvk6I=";
    x86_64-darwin = "sha256-UO1NRpbCA5MtqeRLTGM3FIWdX/ECDW/JG52U756FIv8=";
    aarch64-darwin = "sha256-FqakcG050m52/F6nWlS7VeW0r+77CCIzG1qvBP3Naik=";
  };
}
