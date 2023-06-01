{ lib, rustPlatform, fetchCrate, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "pipe-rename";
  version = "1.6.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-LSkUZ90lS2QGF6f8sFvunuYpw8Cmx8s6JCCOJYo2j7g=";
  };

  cargoHash = "sha256-wvs1uYqm9kb4hp4tgOR3UZzW1rButEWQYpv0Ca9CXe0=";

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
