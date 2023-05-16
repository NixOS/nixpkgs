{ lib
, buildGoModule
, fetchFromGitHub
, fq
, testers
}:

buildGoModule rec {
  pname = "fq";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "0.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lXU2BX0197aqdXAApDM7Gp24XAsTfpv0NrrWUguVVx0=";
  };

  vendorHash = "sha256-sswb9K4y+G+C4esFM9/OVG/VGl34Fx3ma6/zI6V1DWU=";
=======
    hash = "sha256-Fg5J/iLxGUwb2QRZJMHLqK9dBECW9VsiZGX+LyUtyhw=";
  };

  vendorHash = "sha256-sjzGtSBgRybcJvOXM4wKN5pTgihNrjUCMPsc62n3tLk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "." ];

  passthru.tests = testers.testVersion { package = fq; };

  meta = with lib; {
    description = "jq for binary formats";
    homepage = "https://github.com/wader/fq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
