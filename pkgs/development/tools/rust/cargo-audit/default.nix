{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.17.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-fSdh8yCV+2AdAtF4eO2z8+uxOAf2N0IxqIFLw4B8dKE=";
  };

  cargoSha256 = "sha256-YCEQaUcTmZ9zTdGcDQkaVI0Dc8oIBvt840s3x9PUlrg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  buildFeatures = [ "binary-scanning" "fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    homepage = "https://rustsec.org";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/v${version}/cargo-audit/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ basvandijk figsoda jk ];
  };
}
