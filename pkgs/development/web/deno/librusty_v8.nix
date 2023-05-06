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
  version = "0.71.0";
  shas = {
    x86_64-linux = "sha256-52usT7MsLme3o3tjxcRJ0U3iX0fKtnvEvyKJeuL1Bvc=";
    aarch64-linux = "sha256-E7CjpBO1cV5wFtLTIPPltGAyX1OEPjfhnVUQ4u3Mzxs=";
    x86_64-darwin = "sha256-+Vj0SgvenrCuHPSYKFoxXTyfWDFbnUgHtWibNnXwbVk=";
    aarch64-darwin = "sha256-p7BaC2nkZ+BGRPSXogpHshBblDe3ZDMGV93gA4sqpUc=";
  };
}
