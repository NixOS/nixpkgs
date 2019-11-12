{ stdenv, lib, rustPlatform, fetchFromGitHub, openssl, pkg-config, Security, libiconv }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "RustSec";
    repo = "cargo-audit";
    rev = "v${version}";
    sha256 = "1977ykablfi4mc6j2iil0bxc6diy07vi5hm56xmqj3n37ziavf1m";
  };

  cargoSha256 = "0zbnsq0cif0yppn8ygxhcsrshkbf1c801f8waqqb2d1rjsrhb93y";

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
