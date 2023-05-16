{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tar2ext4";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.9.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "hcsshim";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-+GhYeQ27uwg9JOv1qbf1+UbMd+vPXJ05nsXZD9OakzI=";
  };

  sourceRoot = "${src.name}/cmd/tar2ext4";
=======
    sha256 = "sha256-CvXn5b1kEZ2gYqfKSFRNzqkyOAcfcI1/3etRJTKwqog=";
  };

  sourceRoot = "source/cmd/tar2ext4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  vendorHash = null;

  meta = with lib; {
    description = "Convert a tar archive to an ext4 image";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
  };
}
