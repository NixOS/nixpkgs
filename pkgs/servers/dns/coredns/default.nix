{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "coredns";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "sha256-aE+kw854/wjFJqiRC/1gLzRpaVa6EPJPJaKqXtFM+Sw=";
  };

  vendorSha256 = "sha256-1+WgBsknyPcZhvQLffhlWBH1o0pYTFoOG5BviUJYxyA=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
