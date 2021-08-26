{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
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

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ tokyocabinet ncurses ] ++
    lib.optionals enableCairo [ cairo pango ];

  configureFlags =
    lib.optionals (!enableCairo) [ "--disable-x11" "--disable-cairo" ];

  meta = with lib; {
    homepage = "http://duc.zevv.nl/";
    description = "Collection of tools for inspecting and visualizing disk usage";
    license = licenses.gpl2;

    platforms = platforms.all;
    maintainers = [ ];
  };
}
