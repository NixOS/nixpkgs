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

  cargoSha256 = "0d24crgx6wrb1p96w2yww7cs474x2pz4i6f26cry8pf5dwqfsqdm";

  meta = with stdenv.lib; {
    description = "Command line helpers for fuzzing";
    homepage = https://github.com/rust-fuzz/cargo-fuzz;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.ekleog ];
    platforms = platforms.all;
  };
}
