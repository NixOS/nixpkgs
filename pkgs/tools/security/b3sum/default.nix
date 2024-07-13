{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.5.1";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-43O/8s6g9mHkmJcxm1czF+tOB22363olfsIB3Sk/QSc=";
  };

  cargoHash = "sha256-NG5LCfsh9O6HEXOB3AN/2rXFIkshNM6WWANraBKuVLw=";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    mainProgram = "b3sum";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ivan ];
    license = with lib.licenses; [ cc0 asl20 ];
    changelog = "https://github.com/BLAKE3-team/BLAKE3/releases/tag/${version}";
  };
}
