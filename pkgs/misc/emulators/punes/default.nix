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
, alsa-lib
, libX11
, libXrandr
, sndio
}:

mkDerivation rec {
  pname = "punes";
  version = "unstable-2021-07-19";

  src = fetchFromGitHub {
    owner = "punesemu";
    repo = "puNES";
    rev = "15ab85dabb220889419df0c249c06f3db2b09dc0";
    sha256 = "1w0c5lfdl9ha4sxxva6hcpcaa444px6x25471q37l69n71rmjpy8";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace '`$PKG_CONFIG --variable=host_bins Qt5Core`/lrelease' '${qttools.dev}/bin/lrelease'
  '';

  nativeBuildInputs = [ autoreconfHook cmake pkg-config qttools ];

  buildInputs = [ ffmpeg qtbase qtsvg libGLU ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib libX11 libXrandr ]
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
