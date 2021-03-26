{ stdenv, lib, rustPlatform, fetchFromGitHub, openssl, pkg-config, Security, libiconv }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "RustSec";
    repo = "cargo-audit";
    rev = "v${version}";
    sha256 = "sha256-w3wKUAAp9z4iQbx16z5chpKHYxCDLZzJesnIct2Qy4g=";
  };

  cargoSha256 = "sha256-ychF3qbwEjumLyqc+xDI8bbKzvdoRYF/X/idlk+JxDE=";

  buildInputs = [ openssl libiconv ] ++ lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ pkg-config ];

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
