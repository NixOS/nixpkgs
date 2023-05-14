{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "typst-fmt";
  version = "unstable-2023-04-26";

  src = fetchFromGitHub {
    owner = "astrale-sharp";
    repo = pname;
    rev = "cb299645244551bfc91dc4579a2543a0d4cc84b0";
    hash = "sha256-/+m3HkOsBiOAhOqBfv+hPauvDKqfCrwOWGDtYfW5zJQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-0.2.0" = "sha256-6Uezm3E/qGl9303auqjvfWe3KKsqwsHeXUrjWemjJKU=";
    };
  };

  checkFlags = [
    # test_eof is ignored upstream
    "--skip=rules::tests_typst_format::test_eof"
  ];

  meta = with lib; {
    description = "A formatter for the Typst language";
    homepage = "https://github.com/astrale-sharp/typst-fmt";
    license = licenses.mit;
    maintainers = with maintainers; [ geri1701 ];
  };
}
