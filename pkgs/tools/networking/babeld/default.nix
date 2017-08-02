{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babeld-1.8.0";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${name}.tar.gz";
    sha256 = "0v2jkav2sb0rpx3fmi5chhii08lc92pxf306nyha2amq9wib3a0i";
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
