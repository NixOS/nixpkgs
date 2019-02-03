{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "coredns-${version}";
  version = "1.3.1";

  goPackagePath = "github.com/coredns/coredns";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "0aflm0c3qcjcq4dy7yx9f5xlvdm4k0b2awsp3qvbfgyp74by0584";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://coredns.io;
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = [ maintainers.rushmorem maintainers.rtreffer maintainers.deltaevo ];
  };
}
