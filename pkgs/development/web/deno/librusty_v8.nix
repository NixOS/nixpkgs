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
  version = "0.74.1";
  shas = {
    x86_64-linux = "sha256-RaqqMHhfNzzhwduEBuyu90doH4gYUYRToqf33Ef+F1Y=";
    aarch64-linux = "sha256-WKEWmnLJVATwu8FXT1VhVHKcl14pl92sbE9T7rn4ooU=";
    x86_64-darwin = "sha256-uwIVMiWitd/514NR/B041H75JcqLU+8GpiuQ3dOe0G8=";
    aarch64-darwin = "sha256-qt9S+qaFSAafMOiLbJLknVzAm6wDglzodLh9Ep3Kdbc=";
  };
}
