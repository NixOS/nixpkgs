{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "typstfmt";
  version = "unstable-2023-08-22";

  src = fetchFromGitHub {
    owner = "astrale-sharp";
    repo = "typstfmt";
    rev = "578d39fb304020d0c26118e4eeab272868c9d525";
    hash = "sha256-pF0i3yqGOzbN3CMELhZ7JElOUdBZCnp3cLqa9VONHhI=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda geri1701 ];
  };
}
