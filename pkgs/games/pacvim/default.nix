{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation {
  pname = "pacvim";
  version = "2018-05-16";
  src = fetchFromGitHub {
    owner = "jmoon018";
    repo = "PacVim";
    rev = "ca7c8833c22c5fe97974ba5247ef1fcc00cedb8e";
    sha256 = "1kq6j7xmsl5qfl1246lyglkb2rs9mnb2rhsdrp18965dpbj2mhx2";
  };

  buildInputs = [ ncurses ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jmoon018/PacVim";
    description = "PacVim is a game that teaches you vim commands.";
    maintainers = with maintainers; [ infinisil ];
    license = licenses.lgpl3;
    platforms = platforms.unix;
  };
}
