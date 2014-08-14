{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babeld-1.5.0";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${name}.tar.gz";
    sha256 = "0lpm1zras74b71y01fxndrcvfjzb1ny2hh62pjw6idaqpyrp797s";
  };

  preBuild = ''
    makeFlags="PREFIX=$out ETCDIR=$out/etc"
  '';

  meta = {
    homepage = "http://www.pps.univ-paris-diderot.fr/~jch/software/babel/";
    description = "Loop-avoiding distance-vector routing protocol";
    license = stdenv.lib.licenses.mit;
  };
}
