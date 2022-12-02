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
  version = "0.58.0";
  shas = {
    x86_64-linux = "sha256-x4KLjexiLobbrLBvrE99XsVIw2LcUuu2Huk7nRBLRM4=";
    aarch64-linux = "sha256-HSRLRF86nriU5ZkuZhQcqLFFMO4bstP8bR2tgF2XvbU=";
    x86_64-darwin = "sha256-dHrotM/my1DQYGvHHQm726JgaLbC64IvwJGKgw9kZMM=";
    aarch64-darwin = "sha256-QDBF/ssxXMIWEZHSv7e/E75XZVPx/MvGvGI/C45q2bE=";
  };
}
