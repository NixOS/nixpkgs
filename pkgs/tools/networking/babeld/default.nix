{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babeld-1.7.1";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${name}.tar.gz";
    sha256 = "1dl7s2lb40kiysrqhr7zd0s90yfxy6xfsp0fhqgdlwfr99ymx59c";
  };

  preBuild = ''
    makeFlags="PREFIX=$out ETCDIR=$out/etc"
  '';

  meta = {
    homepage = "http://www.pps.univ-paris-diderot.fr/~jch/software/babel/";
    description = "Loop-avoiding distance-vector routing protocol";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu fpletz ];
  };
}
