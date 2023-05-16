{ lib
, rustPlatform
, fetchCrate
<<<<<<< HEAD
=======
, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "xq";
<<<<<<< HEAD
  version = "0.2.44";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-szrt5msjAfiWFMBHVXxqXmLCpvKre8WM/zqCOHwBEP0=";
  };

  cargoHash = "sha256-T8H9Xnvfewf6B60AzBDn3gEps/0/dXiVl2g+eTw+OaQ=";
=======
  version = "0.2.42";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-VR2ZUt0qvQBaFZr7Gui/LywsRrPubQlzYj1PQj05xhY=";
  };

  cargoHash = "sha256-rX0fwJM8sHTuHIsmk9JpgWrTq1EA6Ksx7fFqWqY5R4k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Pure rust implementation of jq";
    homepage = "https://github.com/MiSawa/xq";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
