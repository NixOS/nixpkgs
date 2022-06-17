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
  version = "0.44.1";
  shas = {
    x86_64-linux = "sha256-8aBjN9ukbH+lr3YPdngXxSjPjutBgWv4hEdhYmcvtO4=";
    aarch64-linux = "sha256-h0mxzeA/wB+/zNz0ZKjSBH7lpYrCLRdTgeDGwZypuXE=";
    x86_64-darwin = "sha256-4YXYHhYwCBnb1clxW1ziccHMWsUcGz8Rr8/anCvI1lY=";
    aarch64-darwin = "sha256-3sBeL+YJB1HaEhM76GfABvN/6iWeST7Z6lVu3X8sRjk=";
  };
}
