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
  version = "0.31.0";
  shas = {
    x86_64-linux = "sha256-KPoxq6rZnwghcDR5cMexN8EMeCfyuKoBcTZ3bv1mEpw=";
    aarch64-linux = "sha256-S+lHGwbnCu2uNCIE+R5MljltOIqXpFAxvx0cglV8ZNI=";
    x86_64-darwin = "sha256-o8O+X4SEXP7eY/dfHqe8NT7johtnPJQTBOgApFqOOhY=";
    aarch64-darwin = "sha256-OQNQh6byNn9R0a6madgUMdUxbUv/R9psnwtTSr3BfzE=";
  };
}
