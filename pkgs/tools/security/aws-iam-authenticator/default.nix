{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aws-iam-authenticator";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5QtNAcInp1mUE8SHUUMS8/XURbPx/q8xMsvEEo/rnCs=";
  };

  # Upstream has inconsistent vendoring, see https://github.com/kubernetes-sigs/aws-iam-authenticator/issues/377
  deleteVendor = true;
  vendorSha256 = null;

  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  subPackages = [ "cmd/aws-iam-authenticator" ];

  meta = with lib; {
    homepage = "https://github.com/kubernetes-sigs/aws-iam-authenticator";
    description = "AWS IAM credentials for Kubernetes authentication";
    license = licenses.asl20;
    maintainers = [ maintainers.srhb ];
  };
}
