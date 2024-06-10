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
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "SuperCuber";
    repo = "dotter";
    rev = "v${version}";
    hash = "sha256-Xmdg5ITKWhL5AxTS7z4f9ecigQpBqna+kZclA+mDJhA=";
  };

  cargoHash = "sha256-W8khm9E5f/PROVJDAUr57nAiTEXV4a0fepzV00HoT8c=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  nativeCheckInputs = [ which ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Dotfile manager and templater written in rust 🦀";
    homepage = "https://github.com/SuperCuber/dotter";
    license = licenses.unlicense;
    maintainers = with maintainers; [ linsui ];
    mainProgram = "dotter";
  };
}
