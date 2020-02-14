{ stdenv, fetchFromGitHub, fetchurl, runCommand, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
    rev = version;
    sha256 = "0qy4xb7bxyw2x2ya7zmbkz48wxb69jcnvvj7021f1kyc6wdwcxs7";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "1d42cmpg1yn1ql9isx26kxsxzf5rg6qw6j948skc5p054r0c9n3f";

  meta = with stdenv.lib; {
    description = "Command line helpers for fuzzing";
    homepage = https://github.com/rust-fuzz/cargo-fuzz;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.ekleog ];
    platforms = platforms.all;
  };
}
