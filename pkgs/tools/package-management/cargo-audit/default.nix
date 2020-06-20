{ stdenv, lib, rustPlatform, fetchFromGitHub, openssl, pkg-config, Security, libiconv }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "RustSec";
    repo = "cargo-audit";
    rev = "v${version}";
    sha256 = "0zby9bd64bmrkb229ic7ckn2ycf9bpwsisx2a7z0id0j4mjaca4k";
  };

  cargoSha256 = "1w4618w5yj1205d7s2hq273fb35qfcd7cnxdwxn4pq8x3ahgy4kx";

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
