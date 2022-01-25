{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "coredns";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "sha256-0R/HqwZA/ZK9f0i01anIjwnW0JCfsbQpTBMF68CNRUI=";
  };

  vendorSha256 = "sha256-MiTg1GHeqNJcQSaqWXW/nW4ZdNzoLTgNlLbbn1bm7aA=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
