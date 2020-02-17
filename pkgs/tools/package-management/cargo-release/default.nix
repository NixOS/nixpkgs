{ stdenv, rustPlatform, fetchFromGitHub, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "sunng87";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "1w9w43i5br94vg5m4idabh67p4ffsx2lmc2g0ak2k961vl46wr0q";
  };

  cargoSha256 = "1x54c6wk5cbnqcy1qpsff8lwqxs0d4qf0v71r7wl0kjp8mrmmhl4";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = https://github.com/sunng87/cargo-release;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
