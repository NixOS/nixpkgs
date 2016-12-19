{stdenv, fetchurl, boost, zlib}:

stdenv.mkDerivation {
  name = "panomatic-0.9.4";

  src = fetchurl {
    url = http://aorlinsk2.free.fr/panomatic/bin/panomatic-0.9.4-src.tar.bz2;
    sha256 = "0vfkj3k3y8narwwijh996q2zzprjxbr2fhym15nm4fkq14yw4wwn";
  };

  buildInputs = [ boost zlib ];

  meta = {
    homepage = http://aorlinsk2.free.fr/panomatic/;
    description = "Tool that automates the creation of control points in Hugin";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
