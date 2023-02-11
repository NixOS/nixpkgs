{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
    pname = "license-generator";
    version = "0.8.2";

    src = fetchCrate {
      inherit pname version;
      sha256 = "sha256-Fno29u4lj/2ASLqfl1h+y27f0Mpiw1ET4xUAScEkYrI=";
    };

    cargoHash = "sha256-DgvjJOxoN5FtUa5bKAtBT95vOZK17SZrnwCZHUQrql4=";

    meta = with lib; {
      description = "Command-line tool for generating license files";
      homepage = "https://github.com/azu/license-generator";
      license = licenses.mit;
      maintainers = with maintainers; [ loicreynier ];
    };
}
