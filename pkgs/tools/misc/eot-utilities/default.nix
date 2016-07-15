{stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "eot_utilities";
  version = "1.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://www.w3.org/Tools/eot-utils/eot-utilities-${version}.tar.gz";
    sha256 = "0cb41riabss23hgfg7vxhky09d6zqwjy1nxdvr3l2bh5qzd4kvaf";
  };

  buildInputs = [ pkgconfig ];

  meta = {
    homepage = "http://www.w3.org/Tools/eot-utils/";
    description = "Create Embedded Open Type from OpenType or TrueType font";
    license = stdenv.lib.licenses.w3c;
    maintainers = with stdenv.lib.maintainers; [ leenaars ];
    platforms = with stdenv.lib.platforms; linux; 
  };
}
