{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  autoreconfHook,
  allegro,
  libsamplerate,
  libX11,
  libXext,
  SDL,
  SDL_mixer,
  SDL2,
  SDL2_mixer,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "1oom";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "1oom-fork";
    repo = "1oom";
    rev = "refs/tags/v${version}";
    hash = "sha256-M8UpdIOOMUMNY0e+Cxx/uoLBWKc2x7cv2d4VyLwcMng=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    allegro
    libsamplerate
    libX11
    libXext
    SDL
    SDL_mixer
    SDL2
    SDL2_mixer
    readline
  ];

  outputs = [
    "out"
    "doc"
  ];

  postInstall = ''
    install -d $doc/share/doc/${pname}
    install -t $doc/share/doc/${pname} \
      HACKING NEWS PHILOSOPHY README.md doc/*.txt
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "f"; };

  meta = with lib; {
    homepage = "https://github.com/1oom-fork/1oom";
    description = "Master of Orion (1993) game engine recreation; a more updated fork";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
