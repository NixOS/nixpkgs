{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "lego";
<<<<<<< HEAD
  version = "4.14.0";
=======
  version = "4.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-dIHyorypyaKIv0Jo+iAK25j7NabgmPtNC6eJVwCl0LQ=";
  };

  vendorHash = "sha256-nAEPkikm98xbGQJzsB6YNXgpZVgR4AK/uCPwiQ25OYU=";
=======
    sha256 = "sha256-RotsWr/wUPAAzW9PrUH3DGx2J5beyD+s/PpAUH12gNI=";
  };

  vendorHash = "sha256-6dfwAsCxEYksZXqSWYurAD44YfH4h5p5P1aYZENjHSs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "cmd/lego" ];

  ldflags = [
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    maintainers = teams.acme.members;
  };

  passthru.tests.lego = nixosTests.acme;
}
