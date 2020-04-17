{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, tokyocabinet, ncurses
, cairo ? null, pango ? null
, enableCairo ? stdenv.isLinux
}:

assert enableCairo -> cairo != null && pango != null;

stdenv.mkDerivation rec {
  pname = "duc";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "zevv";
    repo = "duc";
    rev = version;
    sha256 = "1i7ry25xzy027g6ysv6qlf09ax04q4vy0kikl8h0aq5jbxsl9q52";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ tokyocabinet ncurses ] ++
    stdenv.lib.optionals enableCairo [ cairo pango ];

  configureFlags =
    stdenv.lib.optionals (!enableCairo) [ "--disable-x11" "--disable-cairo" ];

  meta = with stdenv.lib; {
    homepage = "http://duc.zevv.nl/";
    description = "Collection of tools for inspecting and visualizing disk usage";
    license = licenses.gpl2;

    platforms = platforms.all;
    maintainers = [ maintainers.lethalman ];
  };
}
