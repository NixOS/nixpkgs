{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aws-iam-authenticator";
<<<<<<< HEAD
  version = "0.6.11";
=======
  version = "0.5.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-4bZnGgf/H2/uLhh8ip8rrA+U0vA+1SO5uhjLK40j3wE=";
  };

  vendorHash = "sha256-RcZqnyZtonE4qeu+llL1OPGPG93/Rx8ESWM5wapZ1BM=";
=======
    sha256 = "sha256-lopOFEWqRWZox/XniQX6OiQPWlmWJpnQ7yFueiTZpss=";
  };

  # Upstream has inconsistent vendoring, see https://github.com/kubernetes-sigs/aws-iam-authenticator/issues/377
  deleteVendor = true;
  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = let PKG = "sigs.k8s.io/aws-iam-authenticator"; in [
    "-s" "-w"
    "-X ${PKG}/pkg.Version=${version}"
    "-X ${PKG}/pkg.BuildDate=1970-01-01T01:01:01Z"
    "-X ${PKG}/pkg.CommitID=${version}"
  ];

  subPackages = [ "cmd/aws-iam-authenticator" ];

  meta = with lib; {
    homepage = "https://github.com/kubernetes-sigs/aws-iam-authenticator";
    description = "AWS IAM credentials for Kubernetes authentication";
    license = licenses.asl20;
    maintainers = [ maintainers.srhb ];
  };
}
