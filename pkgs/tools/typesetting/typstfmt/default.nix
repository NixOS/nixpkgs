{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "typstfmt";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "astrale-sharp";
    repo = "typstfmt";
    rev = version;
    hash = "sha256-LBYsTCjZ+U+lgd7Z3H1sBcWwseoHsuepPd66bWgfvhI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-syntax-0.7.0" = "sha256-yrtOmlFAKOqAmhCP7n0HQCOQpU3DWyms5foCdUb9QTg=";
    };
  };

  meta = with lib; {
    description = "A formatter for the Typst language";
    homepage = "https://github.com/astrale-sharp/typstfmt";
    changelog = "https://github.com/astrale-sharp/typstfmt/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda geri1701 ];
    mainProgram = "typstfmt";
  };
}
