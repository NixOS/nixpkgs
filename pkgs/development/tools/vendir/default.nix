{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vendir";
<<<<<<< HEAD
  version = "0.34.4";
=======
  version = "0.32.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-vendir";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-HdKMPXZIz1n8+170E3Aj7BYquVGgnPwRKJ5CZcqN35M=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-IgPUqIR9xuLEglVqVHz2KvqqCHpCPYv8TX+Z6q5xCNA=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/vendir" ];

  meta = with lib; {
    description = "CLI tool to vendor portions of git repos, github releases, helm charts, docker image contents, etc. declaratively";
    homepage = "https://carvel.dev/vendir/";
    license = licenses.asl20;
    maintainers = with maintainers; [ russell ];
  };
}
