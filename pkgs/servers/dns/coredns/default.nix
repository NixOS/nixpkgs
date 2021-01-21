{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "coredns";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "sha256-F4YiLjWrAjCNorR5dHQ2nzEBVWvJVuDDmAbUXruaPYQ=";
  };

  vendorSha256 = "sha256-QvT1vnvF+gvABh2SzR6vUsj3KCD8ABqZwXQUm3NldM0=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
