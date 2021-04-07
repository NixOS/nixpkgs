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
  version = "0.21.0";
  shas = {
    x86_64-linux = "sha256-oxGCM6jlqafjAfTtFwARxBv/8tiUaD9A2TlLyj/3LlQ=";
    aarch64-linux = "sha256-yeDcrxEp3qeE6/NWEc1v7VoHjlgppIOkcHTNVksXNsM=";
    x86_64-darwin = "sha256-QqdBa59xPxM8eDRzvPxvv9HFVgp2rt+5jiwIOgsi8JE=";
    aarch64-darwin = "sha256-aq2Kjn8QSDMhNg8pEbXkJCHUKmDTNnitq42SDDVyRd4=";
  };
}
