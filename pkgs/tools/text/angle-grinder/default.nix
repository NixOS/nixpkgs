{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "angle-grinder";
<<<<<<< HEAD
  version = "0.19.2";
=======
  version = "0.19.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rcoh";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-/OYIG4s0hH/bkAPxt/x5qHopDIoMN9AJLQ8Sx8USgsM=";
  };

  cargoHash = "sha256-pOW2jFQxaf2zQWL5+URvHVeCAvSI0u8iALPO5fCoqmI=";
=======
    sha256 = "sha256-CAfbV5WKDMjKv2TSdnxpDEqdAwGWME/9PXLcU/TtM2U=";
  };

  cargoHash = "sha256-EDU+8sbCz4eyBwByHJwQc1Z0ftTZakGcYePbpl8sp08=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Slice and dice logs on the command line";
    homepage = "https://github.com/rcoh/angle-grinder";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    mainProgram = "agrind";
  };
}
