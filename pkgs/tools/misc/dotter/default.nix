{ lib
, stdenv
, fetchpatch
, fetchFromGitHub
, rustPlatform
, CoreServices
, which
}:

rustPlatform.buildRustPackage rec {
  pname = "dotter";
  version = "0.12.13";

  src = fetchFromGitHub {
    owner = "SuperCuber";
    repo = "dotter";
    rev = "v${version}";
    hash = "sha256-j3Dj43AbD0V5pZ6mM1uvPsqWAVJrmWyWvwC5NK1cRRY=";
  };

  cargoHash = "sha256-HPs55JBbYObunU0cSm/7lsu/DOk4ne9Ea9MCRJ427zo=";

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
