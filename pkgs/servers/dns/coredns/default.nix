{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "coredns";
  version = "1.6.6";

  goPackagePath = "github.com/coredns/coredns";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "1x8sgchp0kkk5xdharjrq29qxgv1mdzrw3f12s2kchgqf1m6r0sx";
  };

  modSha256 = "10ljggg1g5x00gpgzc5m29n1k5akf0s0g3hkdh8adcbrcz0pgr5c";

  meta = with stdenv.lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
