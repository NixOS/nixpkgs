{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babeld-1.9.0";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${name}.tar.gz";
    sha256 = "0g7nhvd0hhb3jxdzpbqdxnb68375vm6apj2wslkxb70ip6rkk2hj";
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
