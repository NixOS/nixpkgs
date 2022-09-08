{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "deadnix";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "astro";
    repo = "deadnix";
    rev = "v${version}";
    sha256 = "sha256-uvW+PCJdpYHaIIi7YM+kXmHlhQgMbkXBGvAd0mzSb1U=";
  };

  cargoSha256 = "sha256-cDInmOv1yMedJWHzwGT2wmoUd58ZwKh6IDcOvG65RV8=";

  meta = with lib; {
    description = "Find and remove unused code in .nix source files";
    homepage = "https://github.com/astro/deadnix";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
  };
}
