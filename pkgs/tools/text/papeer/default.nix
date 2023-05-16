{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "papeer";
<<<<<<< HEAD
  version = "0.7.2";
=======
  version = "0.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lapwat";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Kdy660FuPjXYF/uqndljmIvA6r+lo3D86W9pK6KqXl0=";
=======
    hash = "sha256-oXhAiw2oYefmF+a8DqjP2f3AY0+WZ1ZdiNG9bEhSQ84=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-3QRSdkx9p0H+zPB//bpWCBKKjKjrx0lHMk5lFm+U7pA=";

  doCheck = false; # uses network

  meta = {
    description = "Convert websites into ebooks and markdown";
    homepage = "https://papeer.tech/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
