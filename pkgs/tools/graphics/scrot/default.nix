{ stdenv, fetchFromGitHub, giblib, xlibsWrapper, autoreconfHook
, autoconf-archive, libXfixes, libXcursor, libXcomposite }:

stdenv.mkDerivation rec {
  pname = "scrot";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = pname;
    rev = version;
    sha256 = "12xq6glg70icwsvbnfw9gm4dahlbnrc7b6adpd0mpf89h4sj2gds";
  };

  nativeBuildInputs = [ autoreconfHook autoconf-archive ];
  buildInputs = [ giblib xlibsWrapper libXfixes libXcursor libXcomposite ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/resurrecting-open-source-projects/scrot";
    description = "A command-line screen capture utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ];
    license = licenses.mit;
  };
}
