{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babeld-1.4.1";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${name}.tar.gz";
    sha256 = "0ykyvg9kkbv5pnkivcv9ncdcsb8bp3gfxv8swpq9jc7bh9aa2ckp";
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
