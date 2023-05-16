{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
<<<<<<< HEAD
  version = "0.9.3";
=======
  version = "0.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "raphlinus";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-FK/+6N81qYyFsisPn5SkpubvWMYO7dLX9iHgNY/tAo4=";
  };

  cargoHash = "sha256-fcVnIb6WPRk133uTMH0xxmEJ3YgsftsTJXjqfOQQPDI=";
=======
    hash = "sha256-AAb+dSJ1oSRuvWu47VvzCeB6pQE6/+u69io2FsZoZHM=";
  };

  cargoHash = "sha256-oOgwZMmrzYBFH1MaE7nMa1SPCACnfqYY3ttOECsnsVY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "A pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
  };
}
