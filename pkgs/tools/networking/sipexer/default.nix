{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sipexer";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "miconda";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/AVOC8Tx5XMDiKmLBq2xUiJaA3K3TnWVXPE+Vzx862I=";
  };

  vendorHash = "sha256-q2uNqKZc6Zye7YimPDrg40o68Fo4ux4fygjVjJdhqQU=";
=======
    sha256 = "sha256-cM40hxHMBH0wT1prSRipAZscSBxkZX7riwCrnLQUT0k=";
  };

  vendorSha256 = "sha256-q2uNqKZc6Zye7YimPDrg40o68Fo4ux4fygjVjJdhqQU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Modern and flexible SIP CLI tool";
    homepage = "https://github.com/miconda/sipexer";
    changelog = "https://github.com/miconda/sipexer/releases/tag/v${version}";
    license = licenses.gpl3Only;
<<<<<<< HEAD
    maintainers = with maintainers; [ astro janik ];
=======
    maintainers = with maintainers; [ astro ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
