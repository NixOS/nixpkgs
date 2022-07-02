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
  version = "0.44.3";
  shas = {
    x86_64-linux = "sha256-0l05QWfWICFTStB0AVGMAzB28MFOe4kH7Y5mT6CxvGc=";
    aarch64-linux = "sha256-G2yZPD1lXHZvEX3CwnijoFyWF2dv6fM07+xK0oYKMVU=";
    x86_64-darwin = "sha256-f0lBrayYNo7ivCqeJcYF5EMEnmrgH+qHLofMzbUJ+Os=";
    aarch64-darwin = "sha256-3DG8IIMeniYLk+GyK0znFpx/f3URxFy5SFMusEPzykU=";
  };
}
