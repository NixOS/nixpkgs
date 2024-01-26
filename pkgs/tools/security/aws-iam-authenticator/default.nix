{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "aws-iam-authenticator";
  version = "0.6.16";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-E/DkCDtnzI6yBEYemlLqxc1r8ZEuX+6jDefaZTRFRek=";
  };

  vendorHash = "sha256-TDsY05jnutNIKx0z6/8vGvsgYCIKBkTxh9mXqk4IR38=";

  ldflags = let PKG = "sigs.k8s.io/aws-iam-authenticator"; in [
    "-s"
    "-w"
    "-X=${PKG}/pkg.Version=${version}"
    "-X=${PKG}/pkg.BuildDate=1970-01-01T01:01:01Z"
    "-X ?${PKG}/pkg.CommitID=${version}"
  ];

  subPackages = [ "cmd/aws-iam-authenticator" ];

  meta = with lib; {
    homepage = "https://github.com/kubernetes-sigs/aws-iam-authenticator";
    description = "AWS IAM credentials for Kubernetes authentication";
    changelog = "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ srhb ];
  };
}
