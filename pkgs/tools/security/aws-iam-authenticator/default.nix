{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aws-iam-authenticator";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zHkuFSpD/4M2DheAgf8QJnG5rLDC/3o6d6ExhN4VX+w=";
  };

  # Upstream has inconsistent vendoring, see https://github.com/kubernetes-sigs/aws-iam-authenticator/issues/377
  deleteVendor = true;
  vendorSha256 = "+Z8sENIMWXP29Piwb/W6i7UdNXVq6ZnO7AZbSaUYCME=";

  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  subPackages = [ "cmd/aws-iam-authenticator" ];

  meta = with lib; {
    homepage = "https://github.com/kubernetes-sigs/aws-iam-authenticator";
    description = "AWS IAM credentials for Kubernetes authentication";
    license = licenses.asl20;
    maintainers = [ maintainers.srhb ];
  };
}
