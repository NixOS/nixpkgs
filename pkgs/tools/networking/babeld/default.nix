{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babeld-1.8.1";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${name}.tar.gz";
    sha256 = "1gq6q1zly40ngs9wl3qa3yjvyb6zbqck82fp3n6w2bi9ymrrq94w";
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
