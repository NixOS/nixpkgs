{ lib, rustPlatform, fetchCrate, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "pipe-rename";
  version = "1.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-AMBdDsn3jS2dXUnEDKZILUlLHS9FIECZhc3EjxLoOZU=";
  };

  cargoSha256 = "sha256-ulNyTRRFtHQ7+sRaKczLiDPIKG2TIcbbsD9x1di2ypw=";

  checkInputs = [ python3 ];

  preCheck = ''
    patchShebangs tests/editors/env-editor.py
  '';

  meta = with lib; {
    description = "Rename your files using your favorite text editor";
    homepage = "https://github.com/marcusbuffet/pipe-rename";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "renamer";
  };
}
