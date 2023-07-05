{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.4.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-rh5xELjiwm5rSFVgIMZUMG4J/VxKKF8xrxX/wK+sVF8=";
  };

  cargoHash = "sha256-q10NC3QH4+ExF4vO6j/Ud8LenzXIuhZC8Yyev+2gJNU=";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ivan ];
    license = with lib.licenses; [ cc0 asl20 ];
    changelog = "https://github.com/BLAKE3-team/BLAKE3/releases/tag/${version}";
  };
}
