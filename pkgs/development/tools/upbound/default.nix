{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "upbound";
<<<<<<< HEAD
  version = "0.19.1";
=======
  version = "0.16.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = "up";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Dr6EKpKVy2DLhivJ42Bx+WJL2L710sQlXroaAm66Gpo=";
  };

  vendorHash = "sha256-J7rZAvEx0jgkhJIEE19rV2WdBCIvkqYzB72ZiABs56U=";
=======
    sha256 = "sha256-7fR6RiyxPgaf2uK/JY9ydwdUcRRhShFK2ij6WVTA/Vc=";
  };

  vendorHash = "sha256-FDwcsf69l8GcMet9zUG2fuyoZgpEujB3A59eWg2GbdI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/docker-credential-up" "cmd/up" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/upbound/up/internal/version.version=v${version}"
  ];

  meta = with lib; {
    description =
      "CLI for interacting with Upbound Cloud, Upbound Enterprise, and Universal Crossplane (UXP)";
    homepage = "https://upbound.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "up";
  };
}
