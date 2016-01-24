{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "2048-in-terminal-${version}";
  version = "2015-01-15";

  src = fetchFromGitHub {
    sha256 = "1fdfmyhh60sz0xbilxkh2y09lvbcs9lamk2jkjkhxhlhxknmnfgs";
    rev = "3e4e44fd360dfe114e81e6332a5a058a4b287cb1";
    repo = "2048-in-terminal";
    owner = "alewmoose";
  };

  buildInputs = [ ncurses ];

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/bin
  '';
  installFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Animated console version of the 2048 game";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
