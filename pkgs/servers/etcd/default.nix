{ stdenv, lib, libpcap, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "etcd-${version}";
  version = "2.3.0";
  rev = "v${version}";
  
  goPackagePath = "github.com/coreos/etcd";

  src = fetchFromGitHub {
    inherit rev;
    owner = "coreos";
    repo = "etcd";
    sha256 = "1cchlhsdbbqal145cvdiq7rzqqi131iq7z0r2hmzwx414k04wyn7";
  };

  goDeps = ./deps.json;

  buildInputs = [ libpcap ];
}
