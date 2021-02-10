{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aws-iam-authenticator";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xfc3a0dik4930va30sbl6687v6i5irv96fwis9lrqh5rjqnblqp";
  };

  vendorSha256 = null;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=v${version}" ];

  subPackages = [ "cmd/aws-iam-authenticator" ];

  meta = with lib; {
    homepage = "https://github.com/kubernetes-sigs/aws-iam-authenticator";
    description = "AWS IAM credentials for Kubernetes authentication";
    license = licenses.asl20;
    maintainers = [ maintainers.srhb ];
  };
}
