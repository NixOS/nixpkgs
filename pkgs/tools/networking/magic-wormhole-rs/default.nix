{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "magic-wormhole-rs";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "magic-wormhole";
    repo = "magic-wormhole.rs";
    rev = version;
    sha256 = "sha256-i4vJ6HmtM42m1x1UtOq9xlmhYIa5ZKXUm1rGFNRprmY=";
  };

  # this patch serves as a workaround for the problems of cargo-vendor described in
  # https://github.com/NixOS/nixpkgs/issues/30742
  # and can probably be removed once the issue is resolved
  cargoPatches = [ ./Cargo.toml.patch ];
  cargoSha256 = "sha256-ujwvwr4GR/rQWnXFfL8sqPyz4QvGeOxwBrT+gf+vjsI=";

  # all tests involve networking and are bound fail
  doCheck = false;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Rust implementation of Magic Wormhole, with new features and enhancements";
    homepage = "https://github.com/magic-wormhole/magic-wormhole.rs";
    license = licenses.eupl12;
    maintainers = with maintainers; [ zeri piegames ];
  };
}
