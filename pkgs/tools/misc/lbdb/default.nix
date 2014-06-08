{ stdenv, fetchurl, perl, finger_bsd }:

let
  version = "0.38";
in

stdenv.mkDerivation {
  name = "lbdb-${version}";
  src = fetchurl {
    url = "http://www.spinnaker.de/debian/lbdb_${version}.tar.gz";
    md5 = "a8e65f1400c90818ff324dc4fd67eba2";
  };

  buildInputs = [ perl ] ++ stdenv.lib.optional (!stdenv.isDarwin) finger_bsd;

  meta = {
    homepage = "http://www.spinnaker.de/lbdb/";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    description = "The Little Brother's Database (lbdb)";
  };
}
