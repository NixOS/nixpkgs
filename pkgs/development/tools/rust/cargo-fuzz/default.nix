{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
    rev = version;
    sha256 = "sha256-kBbwE4ToUud5BDDlGoey2qpp2imzO6t3FcIbV3NTFa8=";
  };

  cargoSha256 = "sha256-GtvflTfwNMPxMsDQoiTYGgrlSfOIhY3X8qJzwS+LJ4Y=";

  doCheck = false;

  meta = with lib; {
    description = "Command line helpers for fuzzing";
    homepage = "https://github.com/rust-fuzz/cargo-fuzz";
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.ekleog ];
  };
}
