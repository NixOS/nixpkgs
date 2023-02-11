{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
    pname = "license-generator";
    version = "0.8.1";

    src = fetchCrate {
      inherit pname version;
      sha256 = "sha256-ZVhsbaJJ9WBcQPx2yikIAQJeBXwC6ZAJkfCRmokNV3I=";
    };

    cargoSha256 = "sha256-Yh9q/aYHXUF2eIFpJ7ccgeyIO5mQMgRDCNr+ZyS166Y=";

    meta = with lib; {
      description = "Command-line tool for generating license files";
      homepage = "https://github.com/azu/license-generator";
      license = licenses.mit;
      maintainers = with maintainers; [ loicreynier ];
    };
}
