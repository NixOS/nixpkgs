{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubernetes-split-yaml";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mogensen";
    repo = "kubernetes-split-yaml";
    rev = "v${version}";
    sha256 = "0b6ivmznbslcqp780v91qc7mrgydzkhf8jbjlwdn1k8rffkwynnd";
  };

  subPackages = ["."];

  vendorSha256 = "0gxvzz5mx84jpanpp9cv7hv1h2j6w4zy42h4wb1zxlidafx3x95x";

  meta = with lib; {
    description = "Split the 'giant yaml file' into one file pr kubernetes resource";
    license = licenses.mit;
    maintainers = with maintainers; [ edlimerkaj ];
    homepage = "https://github.com/mogensen/kubernetes-split-yaml";
  };
}
