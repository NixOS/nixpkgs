{ stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "babeld";
  version = "1.9.1";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${pname}-${version}.tar.gz";
    sha256 = "1d503igqv9s5pgrhvxp1czjy2xfsjhagyyh2iny7g4cjvl0kq6qy";
  };

  preBuild = ''
    makeFlags="PREFIX=$out ETCDIR=$out/etc"
  '';

  passthru.tests.babeld = nixosTests.babeld;

  meta = {
    homepage = http://www.pps.univ-paris-diderot.fr/~jch/software/babel/;
    description = "Loop-avoiding distance-vector routing protocol";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fpletz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
