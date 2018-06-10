{ stdenv, fetchFromGitHub, cmake, SDL2, libGLU_combined, zlib, libjpeg, libogg, libvorbis
, openal, curl }:

stdenv.mkDerivation rec {
  name = "dhewm3-${version}";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "dhewm";
    repo = "dhewm3";
    rev = version;
    sha256 = "1s64xr1ir4d2z01fhldy577b0x80nd1k6my7y1hxp57lggr8dy5y";
  };

  # Add libGLU_combined linking
  patchPhase = ''
    sed -i 's/\<idlib\()\?\)$/idlib GL\1/' neo/CMakeLists.txt
  '';

  preConfigure = ''
    cd "$(ls -d dhewm3-*.src)"/neo
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 libGLU_combined zlib libjpeg libogg libvorbis openal curl ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/dhewm/dhewm3;
    description = "Doom 3 port to SDL";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with maintainers; [ MP2E ];
    platforms = with platforms; linux;
  };
}
