{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "coredns";
  version = "1.6.7";

  goPackagePath = "github.com/coredns/coredns";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "05r0dm8h23s5dafxisya48izc2ywpn5ywvhf9q6m20qkpwr8gd10";
  };

  modSha256 = "0wlffk6wkcyn2lphw2vmdsmzag0wxljcxrvm7sv3i124x2x3yvy4";

  meta = with stdenv.lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
