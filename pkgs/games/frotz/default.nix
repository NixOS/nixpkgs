{ fetchFromGitLab
, libao
, libmodplug
, libsamplerate
, libsndfile
, libvorbis
, ncurses
, which
, pkg-config
, lib, stdenv }:

stdenv.mkDerivation rec {
  version = "2.53";
  pname = "frotz";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "DavidGriffith";
    repo = "frotz";
    rev = version;
    sha256 = "sha256-xVC/iE71W/Wdy5aPGH9DtcVAHWCcg3HkEA3iDV6OYUo=";
  };

  nativeBuildInputs = [ which pkg-config ];
  buildInputs = [ libao libmodplug libsamplerate libsndfile libvorbis ncurses ];
  preBuild = ''
    makeFlagsArray+=(
      CC="cc"
      CFLAGS="-D_DEFAULT_SOURCE -D_XOPEN_SOURCE=600"
      LDFLAGS="-lncursesw -ltinfo"
    )
  '';
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://davidgriffith.gitlab.io/frotz/";
    changelog = "https://gitlab.com/DavidGriffith/frotz/-/raw/${version}/NEWS";
    description = "A z-machine interpreter for Infocom games and other interactive fiction";
    platforms = platforms.unix;
    maintainers = with maintainers; [ nicknovitski  ddelabru ];
    license = licenses.gpl2;
  };
}
