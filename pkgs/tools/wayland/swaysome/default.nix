{ lib
, rustPlatform
, fetchFromGitLab
}:

rustPlatform.buildRustPackage rec {
  pname = "swaysome";
<<<<<<< HEAD
  version = "2.0.0";
=======
  version = "1.1.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "hyask";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-KmGAp0EPnnM+hPRpUGsbt+NU2v5mcPaRUqo0pqUr1L8=";
  };

  cargoHash = "sha256-9sOR99CaTyMQoGMKP2Cag6YNxmgEqNPE/kiJPziqB9U=";
=======
    sha256 = "sha256-E2Oy8ubH4VIpuH4idYNiZJISuYYe+stcUY/atN2JcVw=";
  };

  cargoSha256 = "sha256-S+GcyEYQ4nnVoPMuglTmFdP5j015UyCXMyyhPHa5m8k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Helper to make sway behave more like awesomewm";
    homepage = "https://gitlab.com/hyask/swaysome";
    license = licenses.mit;
    maintainers = with maintainers; [ esclear ];
    platforms = platforms.linux;
  };
}
