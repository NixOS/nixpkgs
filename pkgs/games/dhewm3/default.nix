{ lib, stdenv, fetchFromGitHub, cmake, SDL2, libGLU, libGL, zlib, libjpeg, libogg, libvorbis
, openal, curl }:

stdenv.mkDerivation rec {
  pname = "dhewm3";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "dhewm";
    repo = "dhewm3";
    rev = version;
    sha256 = "0wsabvh1x4g12xmhzs2m2pgri2q9sir1w3m2r7fpy6kzxp32hqdk";
  };

  # Add libGLU libGL linking
  patchPhase = ''
    sed -i 's/\<idlib\()\?\)$/idlib GL\1/' neo/CMakeLists.txt
  '';

  preConfigure = ''
    cd "$(ls -d dhewm3-*.src)"/neo
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 libGLU libGL zlib libjpeg libogg libvorbis openal curl ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://github.com/dhewm/dhewm3";
    description = "Doom 3 port to SDL";
    license = lib.licenses.gpl3;
    maintainers = with maintainers; [ MP2E ];
    platforms = with platforms; linux;
  };
}
