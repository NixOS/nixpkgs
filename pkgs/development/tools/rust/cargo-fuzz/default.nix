{ stdenv, fetchFromGitHub, fetchurl, runCommand, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
    rev = version;
    sha256 = "1d4bq9140bri8cd9zcxh5hhc51vr0s6jadjhwkp688w7k10rq7w8";
  };

  cargoSha256 = "0zxhak79f50m8nw95ny733mk4x2f7kyk6q9v4f7jr2rkcldhgrpr";

  meta = with stdenv.lib; {
    description = "Command line helpers for fuzzing";
    homepage = "https://github.com/rust-fuzz/cargo-fuzz";
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.ekleog ];
    platforms = platforms.all;
  };
}
