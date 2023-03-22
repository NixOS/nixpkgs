{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:

let
  pname = "typst";
  version = "22.03.21.2";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "typst";
    repo = "typst";
    rev = builtins.replaceStrings ["."] ["-"] version;
    hash = "sha256-bJPGs/Bd9nKYDrCCaFT+20+1wTN4YdkV8bGrtOCR4tM=";
  };

  cargoHash = "sha256-tw1OvhTAzB13VSqGa+0mk8sTLRzq9r7tXtYI3Sk7Vyg=";

  cargoBuildFlags = [ "-p typst-cli" ];

  doCheck = true;

  meta = {
    homepage = "https://typst.app/";
    description = "A new markup-based typesetting system that is powerful and easy to learn";
    longDescription = ''
      Typst is a new markup-based typsetting system that is designed to be as
      powerful as LaTeX while being much easier to learn and use. Typst has:
      - Built-in markup for the most common formatting tasks
      - Flexible functions for everything else
      - A tightly integrated scripting system
      - Math typesetting, bibliography management, and more
      - Fast compile times thanks to incremental compilation
      - Friendly error messages in case something goes wrong
    '';
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
