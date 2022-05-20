{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, which }:

rustPlatform.buildRustPackage rec {
  pname = "dotter";
  version = "0.12.10";

  src = fetchFromGitHub {
    owner = "SuperCuber";
    repo = "dotter";
    rev = "v${version}";
    hash = "sha256-uSM7M//3LHzdLSOruTyu46sp1a6LeodT2cCEFsuoPW4=";
  };

  cargoHash = "sha256-JpMEC2HjAQLQiXHSE6L0HBDc0vLhd465wDK2+35aBXA=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  checkInputs = [ which ];

  meta = with lib; {
    description = "A dotfile manager and templater written in rust 🦀";
    homepage = "https://github.com/SuperCuber/dotter";
    license = licenses.unlicense;
    maintainers = with maintainers; [ linsui ];
    mainProgram = "dotter";
  };
}
