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
  version = "0.12.11";

  src = fetchFromGitHub {
    owner = "SuperCuber";
    repo = "dotter";
    rev = "v${version}";
    hash = "sha256-7K0p20FqaYFzOmUAeq1ousAPCeqE4AZoARF3UY4p4bY=";
  };

  cargoHash = "sha256-BN6cdRmhvMjYQlaEa840+syuVKKUQ59TPMKicm40MTk=";

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
