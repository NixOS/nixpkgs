{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, gettext, ncurses }:

stdenv.mkDerivation rec {
  pname = "nudoku";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jubalh";
    repo = pname;
    rev = version;
    sha256 = "12v00z3p0ymi8f3w4b4bgl4c76irawn3kmd147r0ap6s9ssx2q6m";
  };

  # Allow gettext 0.20
  postPatch = ''
    substituteInPlace configure.ac --replace 0.19 0.20
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config gettext ];
  buildInputs = [ ncurses ];

  configureFlags = lib.optional stdenv.hostPlatform.isMusl "--disable-nls";

  meta = with lib; {
    description = "An ncurses based sudoku game";
    homepage = "http://jubalh.github.io/nudoku/";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}

