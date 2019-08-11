{ stdenv, fetchFromGitHub, cmake, pkgconfig, opencv, zlib
, libxml2, freetype, libjpeg, libtiff, swig, openexr
, ilmbase, boost165
, withPython ? true, python35
}:

stdenv.mkDerivation rec {

    name = "yafaray-core-${version}";
    version = "3.3.0";

    src = fetchFromGitHub {
      owner  = "YafaRay";
      repo   = "Core";
      rev    = "v${version}";
      sha256 = "04p3nlg1rv617qf8v1nzjl6f0w43rvi8w9j6l6ck4bvl77v6cjp6";
    };

    preConfigure = ''
      NIX_CFLAGS_COMPILE+=" -isystem ${ilmbase.dev}/include/OpenEXR"
    '';

    buildInputs = [
      cmake pkgconfig boost165 opencv zlib libxml2 freetype libjpeg libtiff
      swig openexr ilmbase
    ] ++ stdenv.lib.optional withPython python35;

    meta = with stdenv.lib; {
      description = "A free, open source raytracer";
      homepage = http://www.yafaray.org;
      maintainers = with maintainers; [ hodapp ];
      license = licenses.lgpl21;
      platforms = platforms.linux;
    };
  }

# TODO: Add optional Ruby support
# TODO: Add Qt support? (CMake looks for it, but what for?)
