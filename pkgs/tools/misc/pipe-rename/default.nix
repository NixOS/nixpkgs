{ lib, rustPlatform, fetchCrate, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "pipe-rename";
  version = "1.4.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-3Jl/G1QqcChwkI5n1zQLBgGxT2CYdh3XdMHkF+V5SG4=";
  };

  cargoSha256 = "sha256-y5BsdkHrjJHNO66MQTbvA6kKx6tLP7jNk5UmAmslz14=";

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
