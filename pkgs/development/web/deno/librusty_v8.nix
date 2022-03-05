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
  version = "0.40.0";
  shas = {
    x86_64-linux = "sha256-VHkopvK6f5lxdFLBywHe0Z+su2g5hgBsLcTxrwFgq0Y=";
    aarch64-linux = "sha256-awWjziqqUDAl9fcLADUjytLFds1y93y5gZoOtvReL9w=";
    x86_64-darwin = "sha256-WlRnGiJK3iFgTjNzr25rvmmiPAICPRLaD5hbys7MoJA=";
    aarch64-darwin = "sha256-zblcAQVwnLQWh85wajg8CalqxycSR+4WGoSC2dnX7jA=";
  };
}
