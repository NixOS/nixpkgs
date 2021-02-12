{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
    rev = version;
    sha256 = "1d4bq9140bri8cd9zcxh5hhc51vr0s6jadjhwkp688w7k10rq7w8";
  };

  cargoSha256 = "1a2y58h48ngyb820p0inl2hxscva52a1p2ps2mva56ksqbmxp781";

  doCheck = false;

  meta = with lib; {
    description = "Command line helpers for fuzzing";
    homepage = "https://github.com/rust-fuzz/cargo-fuzz";
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.ekleog ];
  };
}
