{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.0.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "0p6dbldsilr1jr6r3bhhlk0507zaiyk2j266v60jbph6jc52ysvr";
  };

  cargoSha256 = "1cbvn68bizy3w3668x0j2dpggkd155icv250ry1ry3zz9j44l2b2";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    changelog = "https://github.com/BLAKE3-team/BLAKE3/releases/tag/${version}";
    maintainers = with lib.maintainers; [ fpletz ivan ];
    license = with lib.licenses; [ cc0 asl20 ];
  };
}
