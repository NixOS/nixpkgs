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
  version = "0.55.0";
  shas = {
    x86_64-linux = "sha256-HztOb1r/9tWh0w4zQveBLOh3d6OfnSwQZkIx6drXJ7M=";
    aarch64-linux = "sha256-rP0K875V4f4yHe7unUCpMCQbi7Fips6474gFZph73Ys=";
    x86_64-darwin = "sha256-iiYttjs9h84YqZG8prxudTTi588BuoqA3zc2LkEks5E=";
    aarch64-darwin = "sha256-RBA3fl3YdCqxb00xgl6KTYdbvl75U5Kgrux5N+dZg/g=";
  };
}
