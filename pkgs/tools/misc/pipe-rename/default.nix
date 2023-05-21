{ lib, rustPlatform, fetchCrate, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "pipe-rename";
  version = "1.6.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-vpSzyDswIIKVFEHwTvFvPq3SRoBePHSv4A31rlj4ymU=";
  };

  cargoHash = "sha256-tlG2Vk1YJBZs2mX1/QqIyFqOsnaK9oa+PsYcmKISC4E=";

  nativeCheckInputs = [ python3 ];

  preCheck = ''
    patchShebangs tests/editors/env-editor.py
  '';

  meta = with lib; {
    description = "Rename your files using your favorite text editor";
    homepage = "https://github.com/marcusbuffett/pipe-rename";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "renamer";
  };
}
