{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "coredns";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "sha256-Tegpc6SspDoVPVD6fXNciVEp4/X1z3HMRWxfjc463PM=";
  };

  vendorSha256 = "sha256-fWK8sGd3yycgFz4ipAmYJ3ye4OtbjpSzuK4fwIjfor8=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
