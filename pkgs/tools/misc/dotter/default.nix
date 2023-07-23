{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, rustPlatform
, CoreServices
, which
}:

rustPlatform.buildRustPackage rec {
  pname = "dotter";
  version = "0.12.16";

  src = fetchFromGitHub {
    owner = "SuperCuber";
    repo = "dotter";
    rev = "v${version}";
    hash = "sha256-mAvTy/11a9RGSQpElhpKMzsMC7vA7cbeHsNRy9MnIjw=";
  };

  cargoHash = "sha256-lVhATGh4pP7xj/L8XmPe5fuUUjwPz6qgCtOzIheOvGk=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  nativeCheckInputs = [ which ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A dotfile manager and templater written in rust 🦀";
    homepage = "https://github.com/SuperCuber/dotter";
    license = licenses.unlicense;
    maintainers = with maintainers; [ linsui ];
  };
}
