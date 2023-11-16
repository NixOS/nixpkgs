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
  version = "0.81.0";
  shas = {
    x86_64-linux = "sha256-e77LYm/sus7EY4eiRuEp6G25djDaT4wSD4FBCxy4vcE=";
    aarch64-linux = "sha256-wPfUcuT2Z2sy5nLf8xR3QjGQKk6OsM/45jnYv/Hw+Zs=";
    x86_64-darwin = "sha256-UbnRiywM7b7q3rITZzNeWAuKU+HXXAqVapQ9j5ND6go=";
    aarch64-darwin = "sha256-42d3VGBv5lW1InfzYfWr6Xj0GpyJ6GWswVNtUa8ID30=";
  };
}
