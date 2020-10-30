{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "coredns";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "0ggkpdlwrmyaicn61qyx4m5svmw7px0gfwl8mhhif8dfmjznfkir";
  };

  vendorSha256 = "0fzgqgfmyqfyap0j81ihag0319cq34k3y0a9rxkg9cg23hn1d5gf";

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
