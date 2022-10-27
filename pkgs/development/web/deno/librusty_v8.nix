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
  version = "0.53.1";
  shas = {
    x86_64-linux = "sha256-jMOzvvjnmauVmyeBlTOeVpQB1TcQ0K8D7xXsgjLcp3M=";
    aarch64-linux = "sha256-aRcKpPlliO26xJe2zBym5/+hNmJUIrWu3qXJa9R3Irg=";
    x86_64-darwin = "sha256-JsEx2t8d33xRlh+pmJtk5jvDktfW6nFGdw6oqJ3uYSU=";
    aarch64-darwin = "sha256-ju/qr65m33IyXFL2VQXhvtL7PsxSpi8RrGteIb9dQTU=";
  };
}
