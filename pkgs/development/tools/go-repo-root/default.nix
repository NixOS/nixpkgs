{ stdenv, lib, buildGoPackage, gotools, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "go-repo-root-${version}";
  version = "20140911-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "90041e5c7dc634651549f96814a452f4e0e680f9";
  
  goPackagePath = "github.com/cstrahan/go-repo-root";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/cstrahan/go-repo-root";
    sha256 = "1rlzp8kjv0a3dnfhyqcggny0ad648j5csr2x0siq5prahlp48mg4";
  };

  buildInputs = [ gotools ];
}
