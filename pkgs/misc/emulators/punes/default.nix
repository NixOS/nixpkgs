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
, sndio
}:

mkDerivation rec {
  pname = "punes";
  version = "unstable-2021-06-05";

  src = fetchFromGitHub {
    owner = "punesemu";
    repo = "puNES";
    rev = "07fd123f62b2d075894a0cc966124db7b427b791";
    sha256 = "1wxff7b397ayd2s2v14w6a0zfgklc7y0kv3mkz1gg5x47mnll24l";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace '`$PKG_CONFIG --variable=host_bins Qt5Core`/lrelease' '${qttools.dev}/bin/lrelease'
  '';

  nativeBuildInputs = [ autoreconfHook cmake pkg-config qttools ];

  buildInputs = [ ffmpeg qtbase qtsvg libGLU ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ]
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
