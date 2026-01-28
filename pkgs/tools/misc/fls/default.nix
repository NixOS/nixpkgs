{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:

with import <nixpkgs>
{
  overlays = [
    (import (fetchFromGitHub {
      owner = "oxalica";
      repo = "rust-overlay";
      rev = "fbc7ae3f14d32e78c0e8d7865f865cc28a46b232";
      sha256 = "sha256-R6borgcKeyMIjjPeeYsfo+mT8UdS+OwwbhhStdCfEjg=";
    }))
  ];
};
let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.nightly.latest.default;
    rustc = rust-bin.nightly.latest.default;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "fls";
  version = "8ef20e65c91e92bf22eff588ed57a19c3ed067b8";

  src = fetchFromGitHub {
    owner = "saethlin";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-+dO439SZyo4mEogwVqmoMB702neKwFGxHz5yAlfouGQ=";
  };

  # Cargo.lock is outdated
  cargoPatches = [ ./update-cargo-lock.diff ];

  cargoHash = "sha256-MfcrmolPKka9MHCCCvvzRZXC2vl0/XYUz5Bq0C9J5p0=";

  buildNoDefaultFeatures = true;

  outputs = [ "out" ];

  doCheck = false;

  meta = with lib; {
    description = "Fastest ls in the west";
    longDescription = ''
      fls and lsd are both great ls-like Rust programs, but they're
      slower than the system ls and about 10x the code size. Plus you
      can't actually replace your ls with one of them, because some
      software relies on parsing the output of ls. But even as a user
      experience improvement, I think other projects tell the wrong
      story; modern software does not need to be larger or slower.
    '';
    homepage = "https://github.com/saethlin/fls";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _2gn ];
    platforms = lib.platforms.linux;
  };
}
