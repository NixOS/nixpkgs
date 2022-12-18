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
  version = "0.60.0";
  shas = {
    x86_64-linux = "sha256-2cq9fpKhx3ctZ5Lo2RofXD5bXfVUUN6bRtG453MQMW4=";
    aarch64-linux = "sha256-hjVUzCYdGkc3kMC/cSXDFOaqJmMBi83dqqASS5R2158=";
    x86_64-darwin = "sha256-EyYWfDU0eVFVzSVAHBFUbsppzpHtwe+Fd+z2ZmIub2c=";
    aarch64-darwin = "sha256-2VyEFqWsPZlkEDvNxkmrMCIKfsO7LAO+VvsjSMcyFUo=";
  };
}
