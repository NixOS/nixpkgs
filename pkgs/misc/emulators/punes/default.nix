{ mkDerivation
, stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, qtbase
, qtsvg
, qttools
, autoreconfHook
, cmake
, pkg-config
, ffmpeg
, libGLU
, alsaLib
, sndio
}:

mkDerivation rec {
  pname = "punes";
  version = "unstable-2021-04-25";

  src = fetchFromGitHub {
    owner = "punesemu";
    repo = "puNES";
    rev = "4b4c3495a56d3989544cb56079ce641da8aa9b35";
    sha256 = "1wszvdgm38513v26p14k58shbkxn1qhkn8l0hsqi04vviicad59s";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace '`$PKG_CONFIG --variable=host_bins Qt5Core`/lrelease' '${qttools.dev}/bin/lrelease'
  '';

  nativeBuildInputs = [ autoreconfHook cmake pkg-config qttools ];

  buildInputs = [ ffmpeg qtbase qtsvg libGLU ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ alsaLib ]
    ++ lib.optionals stdenv.hostPlatform.isBSD [ sndio ];

  dontUseCmakeConfigure = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--without-opengl-nvidia-cg"
    "--with-ffmpeg"
  ];

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/punesemu/puNES.git";
  };

  meta = with lib; {
    description = "Qt-based Nintendo Entertaiment System emulator and NSF/NSFe Music Player";
    homepage = "https://github.com/punesemu/puNES";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = with platforms; linux ++ freebsd ++ openbsd ++ windows;
  };
}
