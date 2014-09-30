{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babeld-1.5.1";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${name}.tar.gz";
    sha256 = "1ch9nn2jmmpyq6c7106lzd3cfnxq4ychjx0pvwn960kssn2cgakk";
  };

  preBuild = ''
    makeFlags="PREFIX=$out ETCDIR=$out/etc"
  '';

  meta = {
    homepage = "http://www.pps.univ-paris-diderot.fr/~jch/software/babel/";
    description = "Loop-avoiding distance-vector routing protocol";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
