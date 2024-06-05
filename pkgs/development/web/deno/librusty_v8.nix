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
  version = "0.92.0";
  shas = {
    x86_64-linux = "sha256-4P+s98w6iY/nUt6gBxlXAy2zbrTrP5kVVCCpmuuzuk0=";
    aarch64-linux = "sha256-dcBM8wngo7/CcZTmeZxxXrbrnxX5yGq/NAfOmxW+34g=";
    x86_64-darwin = "sha256-3sjEWLKs90Rs0EhPeXbm+RLrG8dPFVIdbs6nFLZDfA8=";
    aarch64-darwin = "sha256-dTGDfmIIykGQuYRSdPNYIp8tNcODCTi6nCpOrsxMCBE=";
  };
}
