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
  version = "0.36.0";
  shas = {
    x86_64-linux = "sha256-Ala3aT5oXrY+xwzXfB+pLr6gxfoSHcMen9elCbdS9mU=";
    aarch64-linux = "sha256-BQn/gsNnnuzEzmUzEvGZ8twP0QElgOiTgHe++o4OVCI=";
    x86_64-darwin = "sha256-YNgGgkrMdiVMe960LHz7BOB+mb/tIXBwGTveT7zrRMs=";
    aarch64-darwin = "sha256-g2bpxeBVVlsT87jR5VWBArM7yQ/F/MDLeiKHt4u5C5M=";
  };
}
