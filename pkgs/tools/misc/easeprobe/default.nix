{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "easeprobe";
<<<<<<< HEAD
  version = "2.1.1";
=======
  version = "2.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "megaease";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-vdbzDwFpCYVgH9T8e62+1hnMyWsWrT7e6WPaAlBc2H0=";
  };

  vendorHash = "sha256-ZB6q8XvDVSF5/kx2Avq0PYBkYqSoMD6YHhuXRrotFgk=";
=======
    sha256 = "sha256-z+qwmVsznzm6TjvDOT1/8Zy3wUDPFDrjcpxXXHnb4oo=";
  };

  vendorHash = "sha256-N32uSuHAbTfGg+Y1bmngzw4RTx5gR4DGKbSBB0BT+8I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/easeprobe" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
    "-X github.com/megaease/easeprobe/global.Ver=${version}"
    "-X github.com/megaease/easeprobe/pkg/version.REPO=megaease/easeprobe"
  ];

  meta = with lib; {
    description = "A simple, standalone, and lightweight tool that can do health/status checking, written in Go";
    homepage = "https://github.com/megaease/easeprobe";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
