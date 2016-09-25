{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "coredns-${version}";
  version = "001";

  goPackagePath = "github.com/miekg/coredns";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "miekg";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "1ybi0v40bsndiffm41hak3b3w22l1in392zcy75bpf2mklxywnak";
  };

  patches = [ ./pull-278.patch ];

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://coredns.io;
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
