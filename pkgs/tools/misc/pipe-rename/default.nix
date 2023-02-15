{ lib, rustPlatform, fetchCrate, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "pipe-rename";
  version = "1.6.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-95Gj5iy8VYBzpV0kmGhronIR5LSjelfOueBQD/8gbfw=";
  };

  cargoSha256 = "sha256-HiElAPgNeICEVbMBfK6syCoQb5smHhBH1MOuo2swci4=";

  nativeCheckInputs = [ python3 ];

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
