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
  version = "0.42.0";
  shas = {
    x86_64-linux = "sha256-p8wC2r9+PKEabaHj0NF059TBSKOpE+rtZkqk1SXINzQ=";
    aarch64-linux = "sha256-1mQQ5XmR+WcYW6BGfnUdsG4yzhwIal80Y5fWw4XAJ3g=";
    x86_64-darwin = "sha256-a5Mu33gXn2X02WRdtO1hb9JRctmFTiCaLNhScz2D0J8=";
    aarch64-darwin = "sha256-THEFn8nQDktXJlY1zpi2760KAS2eKEQ9O3Y+yqI2OYw=";
  };
}
