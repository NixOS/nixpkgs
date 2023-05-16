{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pulumictl";
<<<<<<< HEAD
  version = "0.0.44";
=======
  version = "0.0.42";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumictl";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-7Q+1shNZ18BZ6W6CslwUZhX0LtxPdTXOSNH5VhBHFxE=";
  };

  vendorHash = "sha256-XOgHvOaHExazQfsu1brYDq1o2fUh6dZeJlpVhCQX9ns=";
=======
    sha256 = "sha256-fs+etB/tzqzV3QbQKa4xqsAjtUkr1BdKtTNvRylnKaY=";
  };

  vendorHash = "sha256-WzfTS68YIpoZYbm6i0USxXyEyR4px+hrNRbsCTXdJsk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s" "-w" "-X=github.com/pulumi/pulumictl/pkg/version.Version=${src.rev}"
  ];

  subPackages = [ "cmd/pulumictl" ];

  meta = with lib; {
    description = "Swiss Army Knife for Pulumi Development";
    homepage = "https://github.com/pulumi/pulumictl";
    license = licenses.asl20;
    maintainers = with maintainers; [ vincentbernat ];
  };
}
