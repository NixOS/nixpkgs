{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
<<<<<<< HEAD
  version = "2.13.3";
=======
  version = "2.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Pte2fOIuezFJ1Hz5MgjRDTIAMJ5r+LO1hKHc3sLu0W4=";
=======
    sha256 = "sha256-asNzvHpDqKuLPy+TgjaiCZ96A/dy6em5EGmVRvyd1YU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  CGO_ENABLED = 0;

<<<<<<< HEAD
  vendorHash = "sha256-McicBVC2niLvP902monJwPMOrQKSum10zeHNcO32/M8=";
=======
  vendorHash = "sha256-ENsKm3D3URCrRUiqqebkgFS//2h9SlLbAQHdjisdGlE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
