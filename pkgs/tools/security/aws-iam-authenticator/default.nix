{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "aws-iam-authenticator";
  version = "0.4.0";

  goPackagePath = "github.com/kubernetes-sigs/aws-iam-authenticator";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ghl2vms9wmvczdl2raqhy0gffxmk24h158gjb5mlw7rggzvb7bg";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/kubernetes-sigs/aws-iam-authenticator";
    description = "AWS IAM credentials for Kubernetes authentication";
    license = licenses.asl20;
    maintainers = [ maintainers.srhb ];
  };
}
