<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
, testers
, relic
}:

buildGoModule rec {
  pname = "relic";
  version = "7.6.1";
=======
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "relic";
  version = "7.5.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sassoftware";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-wOQKSH60AGO6GLaJL1KDK2PzIt8X2V1z1sPhUWVeAG4=";
  };

  vendorHash = "sha256-EZohpGzMDYKUbjSOIfoUbbsABNDOddrTt52pv+VQLdI=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = relic;
    };
  };
=======
    sha256 = "sha256-rm52XrN0554copqIllfaNC9EIZ+6rxVeZWTWR2y9X14=";
  };

  vendorHash = "sha256-389ki4hsx7l2gHSiOHledo/ZP+I3NAkk1K8anq2kfEE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/sassoftware/relic";
    description = "A service and a tool for adding digital signatures to operating system packages for Linux and Windows";
    license = licenses.asl20;
    maintainers = with maintainers; [ strager ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
