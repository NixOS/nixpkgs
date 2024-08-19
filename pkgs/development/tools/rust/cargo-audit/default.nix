{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, zlib
, stdenv
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.21.0-pre.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-WTgvcIYv/0Ng+NVZ6p68QsiwDOMP7pThueS8P9qYgyk=";
  };

  cargoHash = "sha256-IYA1wvJpFwhzqsK6wusYwd8X8awGrv7DR6fdq7KlR3g=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  buildFeatures = [ "fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    mainProgram = "cargo-audit";
    homepage = "https://rustsec.org";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/v${version}/cargo-audit/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ basvandijk figsoda jk ];
  };
}
