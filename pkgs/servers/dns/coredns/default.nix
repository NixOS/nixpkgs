{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "coredns-${version}";
  version = "005";

  goPackagePath = "github.com/miekg/coredns";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "miekg";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "15q8l4apspaw1xbbb9j1d8s2cc5zrgycan6iq597ga9m0vyf7wiw";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://coredns.io;
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = [ maintainers.rushmorem maintainers.rtreffer ];
  };
}
