{ lib, rustPlatform, fetchCrate, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "pipe-rename";
  version = "1.6.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-fAjJDHc6p/+a1RLricpNkww4JLJBAXNMfw1T2HmlxPg=";
  };

  cargoSha256 = "sha256-UvYRegfc/+cFx7kLuhQIYZGla5YCrWXKOsTMlV9c874=";

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
