{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.24.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-BjLcI/44v0kWJbHVNtNP8cXw6IrmpMxNgA4e6RSMsmw=";
  };

  cargoSha256 = "sha256-An7mqZRrnPrv2UL/bej8nRQBz4q+qvafvTIA5X39NuU=";

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

