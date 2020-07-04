{ stdenv, fetchFromGitHub, cmake, pkgconfig, opencv, zlib
, libxml2, freetype, libjpeg, libtiff, swig, openexr
, ilmbase, boost165
, withPython ? true, python3
}:

stdenv.mkDerivation rec {

    pname = "yafaray-core";
    version = "3.4.4";

    src = fetchFromGitHub {
      owner  = "YafaRay";
      repo   = "Core";
      rev    = "v${version}";
      sha256 = "140vnaihz09rdvp0mqgrs26b3a2fv5wm49ar6817p4qklfx71l0g";
    };

    preConfigure = ''
      NIX_CFLAGS_COMPILE+=" -isystem ${ilmbase.dev}/include/OpenEXR"
    '';

    buildInputs = [
      cmake pkgconfig boost165 opencv zlib libxml2 freetype libjpeg libtiff
      swig openexr ilmbase
    ] ++ stdenv.lib.optional withPython python3;

    meta = with stdenv.lib; {
      description = "A free, open source raytracer";
      homepage = "http://www.yafaray.org";
      maintainers = with maintainers; [ hodapp ];
      license = licenses.lgpl21;
      platforms = platforms.linux;
    };
  }

# TODO: Add optional Ruby support
# TODO: Add Qt support? (CMake looks for it, but what for?)
