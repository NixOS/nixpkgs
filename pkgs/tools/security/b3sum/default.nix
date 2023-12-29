{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.5.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-yjMuXL0eW+6mm26LgIjD22WyTjb+KMjKRI68mpGGAZA=";
  };

  cargoHash = "sha256-Ka+5RKRSVQYoLFXE1bEc6fGFQcbrFTVgi6yAoGIDdUI=";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ivan ];
    license = with lib.licenses; [ cc0 asl20 ];
    changelog = "https://github.com/BLAKE3-team/BLAKE3/releases/tag/${version}";
  };
}
