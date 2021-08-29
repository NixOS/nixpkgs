{ lib, stdenv, fetchFromGitHub, giblib, xlibsWrapper, autoreconfHook
, autoconf-archive, libXfixes, libXcursor, libXcomposite }:

stdenv.mkDerivation rec {
  pname = "scrot";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = pname;
    rev = version;
    sha256 = "sha256-4vguodLnCj0sOBLM4oJXTfX1p8hIo3WTwIuViPtZxHQ=";
  };

  nativeBuildInputs = [ autoreconfHook autoconf-archive ];
  buildInputs = [ giblib xlibsWrapper libXfixes libXcursor libXcomposite ];

  meta = with lib; {
    homepage = "https://github.com/resurrecting-open-source-projects/scrot";
    description = "A command-line screen capture utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ];
    license = licenses.mit;
  };
}
