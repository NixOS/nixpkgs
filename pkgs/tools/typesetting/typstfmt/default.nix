{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "typstfmt";
  version = "unstable-2023-08-06";

  src = fetchFromGitHub {
    owner = "astrale-sharp";
    repo = "typstfmt";
    rev = "825d328a593451f0cae36aa4a3d23ee8ed95f6aa";
    hash = "sha256-NRVczIIRKPztrIE6KqohMN4i5S8ywa0eXHiqsvemKU0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-syntax-0.6.0" = "sha256-oAn783W7P8zY8gqPyy/w1goW/tdLJgf0qm2qAEJ9Vto=";
    };
  };

  meta = with lib; {
    description = "A formatter for the Typst language";
    homepage = "https://github.com/astrale-sharp/typstfmt";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda geri1701 ];
  };
}
