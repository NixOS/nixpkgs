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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "RustSec";
    repo = "rustsec";
    rev = "cargo-audit%2Fv${version}";
    sha256 = "sha256-6Jb7ViVY4YcnNvGarnHWyBPnpz7xiHQjumOmVaA8rzg=";
  };

  cargoSha256 = "sha256-31zZMjIFnMIzSmTEACFBE4nSMje9SvE9KzZdoxTg4VM=";

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
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ basvandijk ];
  };
}
