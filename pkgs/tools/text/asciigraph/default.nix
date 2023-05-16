{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "asciigraph";
<<<<<<< HEAD
  version = "0.5.6";
=======
  version = "0.5.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "guptarohit";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ZmH0+UXPUyO90ZI6YsKiTd6Nf8dgZAgm7Qx8PVUkHAU=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-7sobelRCDY8mC5FYyGZmNsvUsEMxRulqPnUucNRN5J8=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/guptarohit/asciigraph";
    description = "Lightweight ASCII line graph ╭┈╯ command line app";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmahut ];
  };
}
