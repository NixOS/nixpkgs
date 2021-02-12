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

  cargoSha256 = "0s4s3dk0k40sabs008iay4jmhwziqxhwf07vh86w2531snjpb4q7";

  cargoPatches = [ ./cargo-lock.patch ];

  meta = {
    description = "BLAKE3 cryptographic hash function";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ivan ];
    license = with lib.licenses; [ cc0 asl20 ];
  };
}
