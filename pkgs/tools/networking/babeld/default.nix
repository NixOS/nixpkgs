{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babeld-1.9.1";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${name}.tar.gz";
    sha256 = "1d503igqv9s5pgrhvxp1czjy2xfsjhagyyh2iny7g4cjvl0kq6qy";
  };

  preBuild = ''
    makeFlags="PREFIX=$out ETCDIR=$out/etc"
  '';

  meta = {
    homepage = http://www.pps.univ-paris-diderot.fr/~jch/software/babel/;
    description = "Loop-avoiding distance-vector routing protocol";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu fpletz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
