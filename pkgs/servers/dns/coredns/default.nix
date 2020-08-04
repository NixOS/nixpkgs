{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "coredns";
  version = "1.7.0";

  goPackagePath = "github.com/coredns/coredns";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "1wayfr26gwgdl0sfrvskb4hkxfmxfy7idbrpw3z4r05fkr2886xj";
  };

  vendorSha256 = "17znl3vkg73hnrfl697rw201nsd5sijgalnbkljk1b4m0a01zik1";

  meta = with stdenv.lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
