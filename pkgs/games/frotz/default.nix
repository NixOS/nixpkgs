{ fetchFromGitLab
, libao
, libmodplug
, libsamplerate
, libsndfile
, libvorbis
, ncurses
, stdenv }:

stdenv.mkDerivation rec {
  version = "2.52";
  pname = "frotz";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "DavidGriffith";
    repo = "frotz";
    rev = version;
    sha256 = "11ca1dz31b7s5vxjqncwjwmbbcr2m5v2rxjn49g4gnvwd6mqw48y";
  };

  buildInputs = [ libao libmodplug libsamplerate libsndfile libvorbis ncurses ];
  preBuild = ''
    makeFlagsArray+=(
      CC="cc"
      CFLAGS="-D_DEFAULT_SOURCE -D_XOPEN_SOURCE=600"
      LDFLAGS="-lncursesw -ltinfo"
    )
  '';
  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://davidgriffith.gitlab.io/frotz/";
    changelog = "https://gitlab.com/DavidGriffith/frotz/-/raw/${version}/NEWS";
    description = "A z-machine interpreter for Infocom games and other interactive fiction.";
    platforms = platforms.unix;
    maintainers = with maintainers; [ nicknovitski  ddelabru ];
    license = licenses.gpl2;
  };
}
