{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, opencv, zlib
, libxml2, freetype, libjpeg, libtiff, swig, openexr
, ilmbase, boost165
, withPython ? true, python3
}:

stdenv.mkDerivation rec {

    pname = "yafaray-core";
    version = "3.5.1";

    src = fetchFromGitHub {
      owner  = "YafaRay";
      repo   = "Core";
      rev    = "v${version}";
      sha256 = "043ixf3h4ay2fahsw9lh0pha82f7ri04mlfhvn2pg251012jvhrx";
    };

    preConfigure = ''
      NIX_CFLAGS_COMPILE+=" -isystem ${ilmbase.dev}/include/OpenEXR"
    '';

    nativeBuildInputs = [ cmake pkg-config ];
    buildInputs = [
      boost165 opencv zlib libxml2 freetype libjpeg libtiff
      swig openexr ilmbase
    ] ++ lib.optional withPython python3;

    meta = with lib; {
      description = "A free, open source raytracer";
      homepage = "http://www.yafaray.org";
      maintainers = with maintainers; [ hodapp ];
      license = licenses.lgpl21;
      platforms = [ "x86_64-linux" ];
    };
  }

# TODO: Add optional Ruby support
# TODO: Add Qt support? (CMake looks for it, but what for?)
