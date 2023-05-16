{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
<<<<<<< HEAD
  version = "5.0.9310";
=======
  version = "3.1.3100";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-gwaNz4OgYs5mAMi/HtLOXoIJA/iHPKX+eiVBP2l2YFU=";
  };

  vendorHash = "sha256-PClKzvpztpry8xsYLfWB/9s/qI5k2m8qHBxkxY0AJqI=";
=======
    sha256 = "sha256-haYS3M3Cg+RBGbH5Af/9qcTkKroqx76r1Fb6Bf08lgY=";
  };

  vendorHash = "sha256-GKgwll9Cl+FMYwn07F7d33VXl4a9lcC7muzNvRzmR4k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    homepage = "https://murex.rocks";
    license = licenses.gpl2;
<<<<<<< HEAD
    maintainers = with maintainers; [ dit7ya kashw2 ];
=======
    maintainers = with maintainers; [ dit7ya ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
