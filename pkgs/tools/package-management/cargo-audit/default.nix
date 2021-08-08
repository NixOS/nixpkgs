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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "RustSec";
    repo = "rustsec";
    rev = "cargo-audit%2Fv${version}";
    sha256 = "0pvb1m9277ysjzydjvx7viybi6bd23ch7sbjyx1wnz45ahrmia1j";
  };

  cargoSha256 = "0cf8kg8vhfqbrkm227rzyl3394n7fsqhqgq13qks7374h5d04haw";

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
