{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.0.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-eWsvCpMG3iWB2cYIKaaP6h9QwKQQrpFNliHTqBtdzVw=";
  };

  cargoSha256 = "sha256-YglKiEz/D5+Dz6CIzWIpoc33bhMSdGTM4MP/uJCxe7E=";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ivan ];
    license = with lib.licenses; [ cc0 asl20 ];
  };
}
