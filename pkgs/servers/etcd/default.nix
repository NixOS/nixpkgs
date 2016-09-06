{ stdenv, lib, libpcap, buildGoPackage, fetchFromGitHub }:

with lib;

buildGoPackage rec {
  name = "etcd-${version}";
  version = "3.0.6"; # After updating check that nixos tests pass
  rev = "v${version}";

  goPackagePath = "github.com/coreos/etcd";

  src = fetchFromGitHub {
    inherit rev;
    owner = "coreos";
    repo = "etcd";
    sha256 = "163qji360y21nr1wnl16nbvvgdgqgbny4c3v3igp87q9p78sdf75";
  };

  goDeps = ./deps.json;

  buildInputs = [ libpcap ];

  meta = {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = https://coreos.com/etcd/;
    maintainers = with maintainers; [offline];
    platforms = with platforms; linux;
  };
}
