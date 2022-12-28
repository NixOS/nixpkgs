{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.25.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-V46uAYnD6U4YZDJAf90ko9kEdsqhZFJhYf4RkgjHmpM=";
  };

  cargoSha256 = "sha256-5ZqXSNvySUQhp1E0FEC6KWIXp+q+Tb12EpvgTvwWgE8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # Tests fail
  doCheck = false;

  meta = with lib; {
    description = "List and diff the public API of Rust library crates between releases and commits. Detect breaking API changes and semver violations";
    homepage = "https://github.com/Enselic/cargo-public-api";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

