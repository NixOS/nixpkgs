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
    sha256 = "11wvy3xp9in5ny6h7hp24dq6asc013vrwc6bqiky83dlzasjwkf6";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://coredns.io;
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = [ maintainers.rushmorem maintainers.rtreffer ];
  };
}
