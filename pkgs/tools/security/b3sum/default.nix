{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.4.1";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-cVl0thk+ENZEhTRvFvtAnHIWM8LzKDKEVSVyI22fh2I=";
  };

  cargoHash = "sha256-v175TKlCZ9Vdd1L2IHv2YX406ZkxRXJmZFKBIMab2gg=";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ivan ];
    license = with lib.licenses; [ cc0 asl20 ];
    changelog = "https://github.com/BLAKE3-team/BLAKE3/releases/tag/${version}";
  };
}
