{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "deadnix";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "astro";
    repo = "deadnix";
    rev = "v${version}";
    sha256 = "sha256-IcxupBqG3/h13sHgNYcO/oHKYfnK1LYd8Ehercz/Z/w=";
  };

  cargoSha256 = "sha256-8l4V9AWrBBnEsdZ0Vs4ruPdu+WQVo2ZbJBmhmo23s2g=";

  meta = with lib; {
    description = "Find and remove unused code in .nix source files";
    homepage = "https://github.com/astro/deadnix";
    license = licenses.gpl3Only;
<<<<<<< HEAD
    mainProgram = "deadnix";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ astro ];
  };
}
