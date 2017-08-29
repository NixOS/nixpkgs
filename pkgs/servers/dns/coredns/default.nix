{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "coredns-${version}";
  version = "010";

  goPackagePath = "github.com/coredns/coredns";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "1f8jclm01w6sc4f7y1lk5gg9bgkvlfdlwh1p8z0sj0v619s68xcj";
  };

  meta = with stdenv.lib; {
    homepage = https://coredns.io;
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = [ maintainers.rushmorem maintainers.rtreffer ];
  };
}
