{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    rev = version;
    sha256 = "0r3nj7jbrpb2gkkfa9h6nv6blrbv6dlrhxg131qnh340q1ysh0x7";
  };

  sourceRoot = "source/b3sum";

  cargoSha256 = "0n8hp83hw7g260vmf4qcicpca75faam7k0zmb0k4cdzsar96gdrr";

  cargoPatches = [ ./cargo-lock.patch ];

  meta = {
    description = "BLAKE3 cryptographic hash function";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ivan ];
    license = with lib.licenses; [ cc0 asl20 ];
  };
}
