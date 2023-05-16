{ lib, rustPlatform, fetchFromGitea }:

rustPlatform.buildRustPackage rec {
  pname = "dabet";
<<<<<<< HEAD
  version = "3.0.1";
=======
  version = "3.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-BYE+GGwf84zENf+lPS98OzZQbXxd7kykWL+B3guyVNI=";
  };

  cargoHash = "sha256-kguQmCXP5+E6e8CSKP18faa93VKToU2pcQixDOBrd+8=";
=======
    sha256 = "sha256-B5z2RUkvztnGCKeVsjp/yzrI8m/6mjBB0DS1yhFZhM4=";
  };

  cargoSha256 = "sha256-v1lc2quqxuNUbBQHaTtIDUPPTMyz8nj+TNCdSjrfrOA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Print the duration between two times";
    homepage = "https://codeberg.org/annaaurora/dabet";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ annaaurora ];
  };
}

