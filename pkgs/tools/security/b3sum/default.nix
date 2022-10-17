{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.3.1";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-Vb4W1TfHppKm2Ib2VHm+917A09JY1oNebymzcQpPm8Q=";
  };

  cargoSha256 = "sha256-cpY69NsbsHgQITdElsNjrhjaih9rgOVpFEv4Pfp9OPw=";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ivan ];
    license = with lib.licenses; [ cc0 asl20 ];
  };
}
