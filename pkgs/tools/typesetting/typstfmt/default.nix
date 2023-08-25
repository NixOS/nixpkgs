{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "typstfmt";
  version = "unstable-2023-08-15";

  src = fetchFromGitHub {
    owner = "astrale-sharp";
    repo = "typstfmt";
    rev = "0e5cf2769ef46ca8f6627c688cb8f848ee279a88";
    hash = "sha256-xdmEixbINjVjXlGwdBqDPcd4YHcT/WeswlRNEwpnfx4=";
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
