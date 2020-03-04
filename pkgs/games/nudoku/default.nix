{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gettext, ncurses }:

stdenv.mkDerivation rec {
  pname = "nudoku";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jubalh";
    repo = pname;
    rev = version;
    sha256 = "0rj8ajni7gssj0qbf1jn51699sadxwsr6ca2718w74psv7acda8h";
  };

  # Allow gettext 0.20
  postPatch = ''
    substituteInPlace configure.ac --replace 0.19 0.20
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig gettext ];
  buildInputs = [ ncurses ];

  configureFlags = stdenv.lib.optional stdenv.hostPlatform.isMusl "--disable-nls";

  meta = with stdenv.lib; {
    description = "An ncurses based sudoku game";
    homepage = "http://jubalh.github.io/nudoku/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}

