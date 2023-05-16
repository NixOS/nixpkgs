{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "unparam";
<<<<<<< HEAD
  version = "unstable-2023-03-12";
=======
  version = "unstable-2021-12-14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "unparam";
<<<<<<< HEAD
    rev = "e84e2d14e3b88193890ff95d72ecb81312f36589";
    sha256 = "sha256-kbEdOqX/p/FrNfWQ2WjXX+lERprSV2EI9l+kapHuFi4=";
  };

  vendorHash = "sha256-gEZFAMcr1okqG2IXcS3hDzZKMINohd2JzxezGbzyeBE=";
=======
    rev = "d0ef000c54e5fbf955d67422b0495b9f29b354da";
    sha256 = "sha256-fH/LcshpOk+UFfQ5dE2eHi6Oi5cm8umeXoyHJvhpAbE=";
  };

  vendorSha256 = "sha256-pfIxWvJYAus4DShTcBI1bwn/Q2c5qWvCwPCwfUsv8c0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  meta = with lib; {
    description = "Find unused parameters in Go";
    homepage = "https://github.com/mvdan/unparam";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
