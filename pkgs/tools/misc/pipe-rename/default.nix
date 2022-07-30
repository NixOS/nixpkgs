{ lib, rustPlatform, fetchCrate, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "pipe-rename";
  version = "1.5.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-NTAZy2ERxznRVld1WzYBchJakOIfs5uJr3yRNt81rMg=";
  };

  cargoSha256 = "sha256-6Rv3rVQEvxdrEp5plhf9NAxpXOD4szwFGU5M6tvakzk=";

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
