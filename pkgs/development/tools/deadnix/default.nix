{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "deadnix";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "astro";
    repo = "deadnix";
    rev = "v${version}";
    sha256 = "sha256-4IK+vv3R3UzF5anH1swypPIzXXZmTCJ2kS2eGUcYvLk=";
  };

  cargoSha256 = "sha256-GmvSrU7wDOKc22GU43oFJoYCYiVKQ5Oe6qrLQXLtcyM=";

  meta = with lib; {
    description = "Find and remove unused code in .nix source files";
    homepage = "https://github.com/astro/deadnix";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
  };
}
