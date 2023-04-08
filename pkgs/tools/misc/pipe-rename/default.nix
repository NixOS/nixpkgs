{ lib, rustPlatform, fetchCrate, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "pipe-rename";
  version = "1.6.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-eMTqKKcFeEICref35/RHWNzpnjLDrG7rjcXjOSAnwIo=";
  };

  cargoSha256 = "sha256-X4wmhyWpjq4EyAVsfdeP76NSC9tcZjZ6woCsRvw0Gzo=";

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
