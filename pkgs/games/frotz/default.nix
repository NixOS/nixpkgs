{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, libao
, libmodplug
, libsamplerate
, libsndfile
, libvorbis
, ncurses
, which
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "frotz";
  version = "2.54";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "DavidGriffith";
    repo = "frotz";
    rev = version;
    hash = "sha256-GvGxojD8d5GVy/d8h3q6K7KJroz2lsKbfE0F0acjBl8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/macports/macports-ports/raw/496e5b91e3b6c9dc6820d77ab60dbe400d1924ee/games/frotz/files/Makefile.patch";
      extraPrefix = "";
      hash = "sha256-P83ZzSi3bhncQ52Y38Q3F/7v1SJKr5614tytt862HRg=";
    })
  ];

  nativeBuildInputs = [ which pkg-config ];
  buildInputs = [ libao libmodplug libsamplerate libsndfile libvorbis ncurses ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://davidgriffith.gitlab.io/frotz/";
    changelog = "https://gitlab.com/DavidGriffith/frotz/-/raw/${version}/NEWS";
    description = "A z-machine interpreter for Infocom games and other interactive fiction";
    mainProgram = "frotz";
    platforms = platforms.unix;
    maintainers = with maintainers; [ nicknovitski ddelabru ];
    license = licenses.gpl2;
  };
}
