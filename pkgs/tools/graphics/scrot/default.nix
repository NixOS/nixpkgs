{ stdenv, fetchFromGitHub, giblib, xlibsWrapper, autoreconfHook
, autoconf-archive, libXfixes, libXcursor }:

stdenv.mkDerivation rec {
  pname = "scrot";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = pname;
    rev = version;
    sha256 = "08gkdby0ysx2mki57z81zlm7vfnq9c1gq692xw67cg5vv2p3320w";
  };

  nativeBuildInputs = [ autoreconfHook autoconf-archive ];
  buildInputs = [ giblib xlibsWrapper libXfixes libXcursor ];

  meta = with stdenv.lib; {
    homepage = http://linuxbrit.co.uk/scrot/;
    description = "A command-line screen capture utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ];
    license = licenses.mit;
  };
}
