{ stdenv, fetchFromGitHub, cmake, docutils, pkgconfig, glib, libpthreadstubs
, libXau, libXdmcp, xcbutil }:

stdenv.mkDerivation {
  name = "xss-lock-git-2018-05-31";

  src = fetchFromGitHub {
    owner = "xdbob";
    repo = "xss-lock";
    rev = "cd0b89df9bac1880ea6ea830251c6b4492d505a5";
    sha256 = "040nqgfh564frvqkrkmak3x3h0yadz6kzk81jkfvd9vd20a9drh7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake docutils glib libpthreadstubs libXau
                  libXdmcp xcbutil ];

  meta = with stdenv.lib; {
    description = "Use external locker (such as i3lock) as X screen saver";
    license = licenses.mit;
    maintainers = with maintainers; [ malyn offline ];
    platforms = platforms.linux;
  };
}
