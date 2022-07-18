{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "RustSec";
    repo = "rustsec";
    rev = "cargo-audit%2Fv${version}";
    sha256 = "sha256-x91x5XjIRXLhs96r06ITbpHCkHoaCaMXH+VCp6f57Gg=";
  };

  cargoSha256 = "sha256-/CzRkdo4kfvRwOZsfyu0zL3UnjEKCBj7wj40jlydSDI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    libiconv
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  buildFeatures = [ "fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    homepage = "https://rustsec.org";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ basvandijk jk ];
  };
}
