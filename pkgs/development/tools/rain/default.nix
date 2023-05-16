{ lib
, buildGoModule
, fetchFromGitHub
, testers
, rain
}:

buildGoModule rec {
  pname = "rain";
<<<<<<< HEAD
  version = "1.4.4";
=======
  version = "1.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-f93BbtMTJFzql3PvkbWZYOnjRoBWcsU3OX1bCBStTqs=";
  };

  vendorHash = "sha256-Z0AB24PdtDREicWjDnVcTM4hhWpF1hpF7Rg/YFgXLN0=";
=======
    sha256 = "sha256-34BHWvXwwdiFotVlV8U6HSkRy9TvJ6DLIC0Mpz//C3w=";
  };

  vendorHash = "sha256-h/9a+o/jiNH2b1XIkbnKXSpCsBtyIhdOGyTNHU+Q/bA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/rain" ];

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = rain;
    command = "rain --version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "A development workflow tool for working with AWS CloudFormation";
    homepage = "https://github.com/aws-cloudformation/rain";
    license = licenses.asl20;
    maintainers = with maintainers; [ jiegec ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
