{ lib
, rustPlatform
, fetchCrate
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.19.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-NPRtSoITOS9i/v9hgdULVSmLaFbXZZeoO4SdqqANDxk=";
  };

  cargoHash = "sha256-cQ2ZEZJ7PgNUxzZXR9Of1R5v2wu1b3xOlENu1DZU/rQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
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
    homepage = "https://rustsec.org";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/v${version}/cargo-audit/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ basvandijk figsoda jk ];
  };
}
