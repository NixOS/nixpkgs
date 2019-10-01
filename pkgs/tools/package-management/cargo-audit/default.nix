{ stdenv, lib, rustPlatform, fetchFromGitHub, openssl, pkg-config, Security, libiconv }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "RustSec";
    repo = "cargo-audit";
    rev = "v${version}";
    sha256 = "0j556dh0lf2l8nq7pfl5bbypgsvp00fh6ckms9wr4dgb8xvpf2r1";
  };

  cargoSha256 = "0200x0bdllq7mpxmp7ly5jarpkc3gpg22gxq8qvdbnmyd39b7wx0";

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
