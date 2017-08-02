{ stdenv, fetchurl, fetchpatch, cmake, pkgconfig, qt4, taglib, chromaprint, ffmpeg }:

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

  patches = [ (fetchpatch {
    url = "https://bitbucket.org/acoustid/acoustid-fingerprinter/commits/632e87969c3a5562a5d4842b03613267ba6236b2/raw";
    sha256 = "15hm9knrpqn3yqrwyjz4zh2aypwbcycd0c5svrsy1fb2h2rh05jk";
  }) ];

  meta = with stdenv.lib; {
    homepage = https://acoustid.org/fingerprinter;
    description = "Audio fingerprinting tool using chromaprint";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; linux;
  };
}
