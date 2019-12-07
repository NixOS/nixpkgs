{ mkDerivation, lib, fetchFromGitHub
, cmake, git, pkgconfig, wget, zip
, qtbase, qtx11extras
, libdwarf, libjpeg_turbo, libunwind, lzma, tinyxml, libX11
, SDL2, SDL2_gfx, SDL2_image, SDL2_ttf
, freeglut, libGLU
, fetchpatch
}:

mkDerivation {
  pname = "vogl";
  version = "2016-05-13";

  src = fetchFromGitHub {
    owner  = "deepfire";
    repo   = "vogl";
    rev    = "cbc5f1853e294b363f16c4e00b3e0c49dbf74559";
    sha256 = "17gwd73x3lnqv6ccqs48pzqwbzjhbn41c0x0l5zzirhiirb3yh0n";
  };

  patches = [
    (fetchpatch {
      name = "fix-qt59.patch";
      url = "https://github.com/ValveSoftware/vogl/commit/be3d85f.patch";
      sha256 = "1yh4jd35mds337waqxdw3w22w7ghn05b5jm7fb4iihl39mhq6qyv";
    })
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    git wget zip
    qtbase qtx11extras
    libdwarf libjpeg_turbo libunwind lzma tinyxml libX11
    SDL2 SDL2_gfx SDL2_image SDL2_ttf
    freeglut libGLU
  ];

  dontUseCmakeBuildDir = true;
  preConfigure = ''
    cmakeDir=$PWD
    mkdir -p vogl/vogl_build/release64 && cd $_
  '';
  cmakeFlags = [
    "-DCMAKE_VERBOSE=On"
    "-DBUILD_X64=On"
  ];

  meta = with lib; {
    description = "OpenGL capture / playback debugger.";
    homepage = https://github.com/ValveSoftware/vogl;
    license = licenses.mit;
    maintainers = [ maintainers.deepfire ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    broken = true;
  };
}
