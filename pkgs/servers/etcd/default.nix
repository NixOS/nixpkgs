{ stdenv, lib, libpcap, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "etcd-${version}";
  version = "3.0.6";
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
}
