{ cmake
, fetchFromGitHub
, freetype
, ilmbase
, lib
, libjpeg
, libtiff
, libxml2
, opencv
, openexr
, pkg-config
, stdenv
, swig
, zlib
, withPython ? true, python3
}:

stdenv.mkDerivation rec {
  pname = "libyafaray";
  version = "unstable-2022-09-17";

  src = fetchFromGitHub {
    owner  = "YafaRay";
    repo   = "libYafaRay";
    rev    = "6e8c45fb150185b3356220e5f99478f20408ee49";
    sha256 = "sha256-UVBA1vXOuLg4RT+BdF4rhbZ6I9ySeZX0N81gh3MH84I=";
  };

  postPatch = ''
    sed '1i#include <memory>' -i \
      include/geometry/poly_double.h include/noise/noise_generator.h # gcc12
  '';

  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -isystem ${ilmbase.dev}/include/OpenEXR"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    freetype
    ilmbase
    libjpeg
    libtiff
    libxml2
    opencv
    openexr
    swig
    zlib
  ] ++ lib.optional withPython python3;

  meta = with lib; {
    description = "Free, open source raytracer";
    downloadPage = "https://github.com/YafaRay/libYafaRay";
    homepage = "http://www.yafaray.org";
    maintainers = with maintainers; [ hodapp ];
    license = licenses.lgpl21;
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}

# TODO: Add optional Ruby support
# TODO: Add Qt support? (CMake looks for it, but what for?)
