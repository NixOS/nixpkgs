{ stdenv, fetchFromGitHub, giblib, xlibsWrapper, autoreconfHook
, autoconf-archive, libXfixes, libXcursor }:

stdenv.mkDerivation rec {
  pname = "scrot";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = pname;
    rev = version;
    sha256 = "0x70hd59ik37kqd8xqpwrz46np01jv324iz28x2s0kk36d7sblsj";
  };

  nativeBuildInputs = [ autoreconfHook autoconf-archive ];
  buildInputs = [ giblib xlibsWrapper libXfixes libXcursor ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/resurrecting-open-source-projects/scrot";
    description = "A command-line screen capture utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ];
    license = licenses.mit;
  };
}
