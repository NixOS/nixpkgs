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
  version = "unstable-2021-09-11";

  src = fetchFromGitHub {
    owner = "punesemu";
    repo = "puNES";
    rev = "60ca36fcb066c41d0b3f2b550ca94dc7d12d84d6";
    sha256 = "JOi6AE1bpAc/wj9fQqHrUNc6vceeUyP0phT2f9kcJTY=";
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
    description = "Qt-based Nintendo Entertainment System emulator and NSF/NSFe Music Player";
    homepage = "https://github.com/punesemu/puNES";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = with platforms; linux ++ freebsd ++ openbsd ++ windows;
  };
}
