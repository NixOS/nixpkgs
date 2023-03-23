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
  version = "0.17.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-qsHy4MKQHBzChcOJ9TrlUbEnEtVxlzxDgZlahhDsoxM=";
  };

  cargoSha256 = "sha256-7uBRybAkexBl3SldV4qudwPZ8JcKCUaAlwbAcT9JXy8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  buildFeatures = [ "fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    homepage = "https://rustsec.org";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/${version}/cargo-audit/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ basvandijk figsoda jk ];
  };
}
