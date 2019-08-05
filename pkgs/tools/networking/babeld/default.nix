{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babeld-1.8.5";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${name}.tar.gz";
    sha256 = "1i2v7npl9aykq8d6zhkinqnbdpqx5x910dqkrv30fib0fp19jb90";
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
