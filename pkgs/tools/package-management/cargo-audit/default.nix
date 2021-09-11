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
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "RustSec";
    repo = "rustsec";
    rev = "cargo-audit%2Fv${version}";
    sha256 = "1rmhizgld35996kzp3fal2zl20aqpnmkzx0clc80n30p814isdrw";
  };

  cargoSha256 = "10li9w3m4xxb8943802y74dgb1wsgjkn74hwn2x47c0w0yjiig7p";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    libiconv
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  # enables `cargo audit fix`
  cargoBuildFlags = [ "--features fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    homepage = "https://rustsec.org";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ basvandijk ];
  };
}
