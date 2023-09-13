{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "typstfmt";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "astrale-sharp";
    repo = "typstfmt";
    rev = version;
    hash = "sha256-d0vlZqg0RcRvZM7xYdMLX2/UeolUbqZ9H4drJRRKBmc=";
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
  };
}
