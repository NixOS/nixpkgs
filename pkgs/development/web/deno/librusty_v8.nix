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
  version = "0.45.0";
  shas = {
    x86_64-linux = "sha256-yZw6zwEhJyRntqOmyk03N+sHxzIrbY/e67AQ21ePlAU=";
    aarch64-linux = "sha256-2p21Smm5wZycv9u+yDbyerKTjSTB7yau5WC2aJ+Vr8w=";
    x86_64-darwin = "sha256-HO287V+iBwdqKZUWhZJnuGJO9RE4wGG4cQMN8CkB7WQ=";
    aarch64-darwin = "sha256-ekoMhWMQpBUdM7R7i82NWrNtQMNqCujNYy1ijOxT64U=";
  };
}
