{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sd-local";
<<<<<<< HEAD
  version = "1.0.48";
=======
  version = "1.0.46";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-cjPqVdHJt1/kxFCdjOKQIvq1V3KppHPeWozrawxdJek=";
  };

  vendorHash = "sha256-uHu8jPPQCJAhXE+Lzw5/9wyw7sL5REQJsPsYII+Nusc=";
=======
    sha256 = "sha256-+Z12atz6fSM5FJFOqUhjalxkP/1Kkm3xWgwUVlB9JvM=";
  };

  vendorSha256 = "sha256-sgCUho8KFt0iFEuupQdMV6IZTVCsTXsNqv2ab5jp0mI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  meta = with lib; {
    description = "screwdriver.cd local mode";
    homepage = "https://github.com/screwdriver-cd/sd-local";
    license = licenses.bsd3;
    maintainers = with maintainers; [ midchildan ];
  };
}
