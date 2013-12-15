{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babeld-1.4.3";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${name}.tar.gz";
    sha256 = "18qb0g7pxxgl9j0jwpyzhxk2h8bf26sk5bwmnqxv34a5f6lhzf6h";
  };

  preBuild = ''
    makeFlags="PREFIX=$out ETCDIR=$out/etc"
  '';

  meta = {
    homepage = "http://www.pps.univ-paris-diderot.fr/~jch/software/babel/";
    description = "Loop-avoiding distance-vector routing protocol";
    license = "MIT";
  };
}
