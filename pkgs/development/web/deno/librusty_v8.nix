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
  version = "0.22.3";
  shas = {
    x86_64-linux = "sha256-RS1fUuTm6zhln67ank6Sit9nhGyKij1UsJ77ezffCh8=";
    aarch64-linux = "sha256-E7SSFYODO8diPmEvpJyzAcltrh7YUXhWlqsRytFRmtA=";
    x86_64-darwin = "sha256-29XTC7RoUDNJq46WkLCQT1vCuv4dzBrp8no6vVCsQ2g=";
    aarch64-darwin = "sha256-UZHhKUjWQGklH26z2Kc2J7VwlV83LWl5n3YZt5ryKrY=";
  };
}
