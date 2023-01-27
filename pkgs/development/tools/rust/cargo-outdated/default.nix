{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, curl
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.11.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-SkFMdE7VAZrT7e5SMrfW8bBA6zPqQV7LhSy3OmshUAs=";
  };

  cargoSha256 = "sha256-ZcG/4vyrcJNAMiZdR3MFyqX5Udn8wGAfiGT5uP1BSMo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    curl
    Security
    SystemConfiguration
  ];

  meta = with lib; {
    description = "A cargo subcommand for displaying when Rust dependencies are out of date";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    changelog = "https://github.com/kbknapp/cargo-outdated/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ ivan ];
  };
}
