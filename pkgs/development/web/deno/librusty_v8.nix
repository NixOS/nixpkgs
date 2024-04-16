# auto-generated file -- DO NOT EDIT!
{ stdenv, fetchurl }:

let
  fetch_librusty_v8 = args: fetchurl {
    name = "librusty_v8-${args.version}";
    url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
    sha256 = args.shas.${stdenv.hostPlatform.system};
    meta = { inherit (args) version; };
  };
in
fetch_librusty_v8 {
  version = "0.90.1";
  shas = {
    x86_64-linux = "sha256-lEGvxBY91cg4GOTUCoLnKeZOcKOl+sdASe/q+s3epkM=";
    aarch64-linux = "sha256-Z9cR1cIBlAFcPghFIMHzW0JP8g5yioK2Vgk1/tGEO0s=";
    x86_64-darwin = "sha256-F/r36lmeQeraotkjK7F7XapXmmMZRRCoD4b5wR0gpCY=";
    aarch64-darwin = "sha256-pE2wGU8YYU4pQlc8oQRYsEx2b0MTkGAwVrn6xW22vrk=";
  };
}
