{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.20.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-59A3RPdltDfMDPTFbBHcnJoFEp718xvYgg6v4MvsxaQ=";
  };

  cargoSha256 = "sha256-GEttxHtdOYMijv1xxK7U0d8WNwJcpqJNgDYKgCV/zVw=";

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

