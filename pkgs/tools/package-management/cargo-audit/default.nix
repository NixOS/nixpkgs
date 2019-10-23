{ stdenv, lib, rustPlatform, fetchFromGitHub, openssl, pkg-config, Security, libiconv }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "RustSec";
    repo = "cargo-audit";
    rev = "v${version}";
    sha256 = "0yd3qj475hh394f1ya0hwki3pbzkfyz5cssy28cq9bimibxhyfd8";
  };

  cargoSha256 = "0ba4xrjrh8cbi4pksax3gs7jaiw5mrb9hdrdwaghkikmiza1c08g";

  buildInputs = [ openssl libiconv ] ++ lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ pkg-config ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    homepage = "https://rustsec.org";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ basvandijk ];
    platforms = platforms.all;
  };
}
