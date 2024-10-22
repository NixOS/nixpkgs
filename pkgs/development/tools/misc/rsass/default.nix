{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "rsass";
  version = "0.28.10";

  src = fetchCrate {
    pname = "rsass-cli";
    inherit version;
    hash = "sha256-/2U1+kCRpM36r2fHB6Hditnm2dSVHh08M0RIi3AIe44=";
  };

  cargoHash = "sha256-pCQOFBs+lNdjcyOqZ/GjJyOthepnaWAM1feEpegdrDo=";

  meta = with lib; {
    description = "Sass reimplemented in rust with nom";
    mainProgram = "rsass";
    homepage = "https://github.com/kaj/rsass";
    changelog = "https://github.com/kaj/rsass/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
