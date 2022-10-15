{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "rsass";
  version = "0.26.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Ksub+VYTbaWbFpHJFrMr6Dnx6LOnEOUlI2qHhCfbS40=";
  };

  cargoSha256 = "sha256-ugG4ivQ2NzLJeZss7h9TME2Aipurl1LZBgxt1cYaK2E=";

  buildFeatures = [ "commandline" ];

  meta = with lib; {
    description = "Sass reimplemented in rust with nom";
    homepage = "https://github.com/kaj/rsass";
    changelog = "https://github.com/kaj/rsass/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
