{ fetchFromGitHub, rust-bindgen-unwrapped }:

rust-bindgen-unwrapped.overrideAttrs (old: rec {
  version = "0.56.0";

  # The version we need can't be fetched via fetchCrate yet, because
  # only version from 0.61.0 upwards exist on crates.io.
  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rust-bindgen";
    rev = "v${version}";
    sha256 = "bqAQrECDz8WMM5wAsAcmZlbeGZ8ngpakvpC1W/AKfCU=";
  };

  cargoDeps = old.cargoDeps.overrideAttrs (_: {
    inherit src;

    name = "${old.pname}-${version}-vendor.tar.gz";
    outputHash = "17hxpakwpxp2nva0bk621h7bn9zjlr5jx3d3m82ncgai44hg77cp";
  });
})
