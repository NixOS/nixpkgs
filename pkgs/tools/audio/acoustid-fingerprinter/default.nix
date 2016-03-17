{ stdenv, fetchurl, cmake, pkgconfig, qt4, taglib, chromaprint, ffmpeg }:

stdenv.mkDerivation rec {
  name = "acoustid-fingerprinter-${version}";
  version = "0.6";

  src = fetchurl {
    url = "http://bitbucket.org/acoustid/acoustid-fingerprinter/downloads/"
        + "${name}.tar.gz";
    sha256 = "0ckglwy95qgqvl2l6yd8ilwpd6qs7yzmj8g7lnxb50d12115s5n0";
  };

  buildInputs = [ cmake pkgconfig qt4 taglib chromaprint ffmpeg ];

  cmakeFlags = [ "-DTAGLIB_MIN_VERSION=${(builtins.parseDrvName taglib.name).version}" ];

  meta = with stdenv.lib; {
    homepage = "http://acoustid.org/fingerprinter";
    description = "Audio fingerprinting tool using chromaprint";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with maintainers; [ ehmry ];
  };
}
