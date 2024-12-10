{
  lib,
  stdenv,
  fetchurl,
  cmake,
  boost,
  eigen2,
  lua,
  luabind,
  libGLU,
  libGL,
  SDL,
}:

stdenv.mkDerivation rec {
  pname = "soi";
  version = "0.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/soi/Spheres%20of%20Influence-${version}-Source.tar.bz2";
    name = "${pname}-${version}.tar.bz2";
    sha256 = "03c3wnvhd42qh8mi68lybf8nv6wzlm1nx16d6pdcn2jzgx1j2lzd";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    lua
    luabind
    libGLU
    libGL
    SDL
  ];

  cmakeFlags = [
    "-DEIGEN_INCLUDE_DIR=${eigen2}/include/eigen2"
    "-DLUABIND_LIBRARY=${luabind}/lib/libluabind09.a"
  ];

  meta = with lib; {
    description = "A physics-based puzzle game";
    mainProgram = "soi";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.free;
    downloadPage = "https://sourceforge.net/projects/soi/files/";
  };
}
