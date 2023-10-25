{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "typstfmt";
  version = "unstable-2023-07-15";

  src = fetchFromGitHub {
    owner = "astrale-sharp";
    repo = "typstfmt";
    rev = "dd7715ee4bcb8637e207c21222f3168cfc384e9e";
    hash = "sha256-m5PN19JxMRKRVHzoxl5n6osz3bZlBNO1hxgfQMxJuok=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "svg2pdf-0.5.0" = "sha256-yBQpvDAnJ7C0PWIM/o0PzOg9JlDZCEiVdCTDDPSwrmE=";
      "typst-0.6.0" = "sha256-igNAs3946Mq8GjOSrDnmcIxjrVMPbYGC86EUHIDAugM=";
    };
  };

  meta = with lib; {
    description = "A formatter for the Typst language";
    homepage = "https://github.com/astrale-sharp/typstfmt";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda geri1701 ];
  };
}
