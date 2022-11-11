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
  version = "0.54.0";
  shas = {
    x86_64-linux = "sha256-V7xBGdKtLZRRNoRyvY/8a3Cvw12zo8tz76ZR72xmG6U=";
    aarch64-linux = "sha256-/KIZ2Feli7VNdgFUU+MC5QZ8dQJ88TKfjz/SOoux1zg=";
    x86_64-darwin = "sha256-xBDMDvWFZPMwJb3alQe7ZuboTm2aFOh9F7memuHo180=";
    aarch64-darwin = "sha256-Z62rnm8X0cro7HBBv5pbkvQJd+AW+wF2tthH1+5a0nU=";
  };
}
