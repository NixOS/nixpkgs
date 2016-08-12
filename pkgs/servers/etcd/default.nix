{ stdenv, lib, libpcap, buildGoPackage, fetchFromGitHub, fetchgit }:

buildGoPackage rec {
  name = "etcd-${version}";
  version = "2.3.7";
  rev = "v${version}";
  
  goPackagePath = "github.com/coreos/etcd";

  src = fetchFromGitHub {
    inherit rev;
    owner = "coreos";
    repo = "etcd";
    sha256 = "07rdnhcpnvnkxj5pqacxz669rzn5vw2i1zmf6dd4nv7wpfscdw9f";
  };

  goDeps = import ./deps.nix { inherit fetchgit; };

  buildInputs = [ libpcap ];
}
