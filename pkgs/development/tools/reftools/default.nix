{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
<<<<<<< HEAD
  pname = "reftools";
  version = "unstable-2021-02-13";

  src = fetchFromGitHub {
    owner = "davidrjenni";
    repo = "reftools";
    rev = "40322ffdc2e46fd7920d1f8250051bbd2f3bd34d";
    sha256 = "sha256-fHWtUoVK3G0Kn69O6/D0blM6Q/u4LuLinT6sxF18nFo=";
  };
=======
  pname = "reftools-unstable";
  version = "2019-12-21";
  rev = "65925cf013156409e591f7a1be4df96f640d02f4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  vendorSha256 = null;

  doCheck = false;

  excludedPackages = "cmd/fillswitch/test-fixtures";

<<<<<<< HEAD
=======
  src = fetchFromGitHub {
    inherit rev;

    owner = "davidrjenni";
    repo = "reftools";
    sha256 = "18jg13skqi2v2vh2k6jvazv6ymhhybangjd23xn2asfk9g6cvnjs";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Refactoring tools for Go";
    homepage = "https://github.com/davidrjenni/reftools";
    license = licenses.bsd2;
    maintainers = with maintainers; [ kalbasit ];
<<<<<<< HEAD
=======
    platforms = platforms.linux ++ platforms.darwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
